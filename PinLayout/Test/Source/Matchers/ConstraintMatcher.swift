//
// Created by René Pirringer
//

import Foundation
import Hamcrest
import UIKit


private func findSuperView(_ first:UIView, _ second:UIView) -> UIView? {

	var view = first
	while let superview = view.superview {
		if (superview == second) {
			return superview
		}
		view = superview
	}
	return findSuperView(first, second.superview)
}

public func findSuperView(_ first:UIView?, _ second:UIView?) -> UIView? {
	if let f = first {
		if let s = second {
			return findSuperView(f, s)
		}
	}
	return nil
}

private func hasMatchingConstraint(_ view: UIView, to: AnyObject?, attribute: NSLayoutConstraint.Attribute, gap: CGFloat, priority: UILayoutPriority, relatedBy relation: NSLayoutConstraint.Relation = .equal) -> MatchResult {

	if let commonSuperView = findSuperView(view, view.superview) {

		if let toItem = to {

			let firstAttribute = attribute
			var secondAttribute = attribute
			var firstItem: AnyObject = view
			var secondItem: AnyObject = toItem

			if (commonSuperView != view && commonSuperView != view.superview ) {
				secondAttribute = inverseAttribute(attribute)
			}

			if (commonSuperView !== secondItem) {
				secondAttribute = inverseAttribute(attribute)
			}

			if (toItem is UILayoutSupport) {
				secondAttribute = inverseAttribute(attribute)
			}


			if (attribute == secondAttribute && (attribute == .bottom || attribute == .right || attribute == .trailing )) {
				swap(&firstItem, &secondItem)
			}

			//if (attribute == .Bottom || attribute == .Right || attribute == .Trailing) {
				//swap(&firstAttribute, &secondAttribute)
			//}

			for constraint in commonSuperView.constraints {

				if (constraint.firstAttribute == firstAttribute &&
						constraint.secondAttribute == secondAttribute &&
						constraint.firstItem === firstItem &&
						constraint.secondItem === secondItem &&
						constraint.relation == relation &&
						constraint.constant == CGFloat(gap) &&
						constraint.priority == priority &&
						constraint.isActive
					 ) {
					return .match
				}
			}
		}
	}
	return .mismatch(nil)
}





public func isPinned<T:UIView>(_ attribute: NSLayoutConstraint.Attribute, toView: UIView?, gap: CGFloat, priority: UILayoutPriority = UILayoutPriority.required, relatedBy relation: NSLayoutConstraint.Relation = .equal) -> Matcher<T> {
	return Matcher("view is pinned \(descriptionOfAttribute(attribute)) to its superview with gap:\(gap)") {
		(value: T) -> MatchResult in
		if let toViewUnwrapped = toView {
			return hasMatchingConstraint(value, to: toViewUnwrapped, attribute: attribute, gap: gap, priority: priority, relatedBy: relation)
		} else {
			return hasMatchingConstraint(value, to: value.superview, attribute: attribute, gap: gap, priority: priority, relatedBy: relation)
		}
	}
}

public func isPinned<T:UIView>(_ attribute: NSLayoutConstraint.Attribute, toView: UIView?) -> Matcher<T> {
	return isPinned(attribute, toView: toView, gap: 0)
}

public func isPinned<T:UIView>(_ attribute: NSLayoutConstraint.Attribute) -> Matcher<T> {
	return isPinned(attribute, toView: nil, gap: 0)
}

public func isPinned<T:UIView>(_ attribute: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation) -> Matcher<T> {
	return isPinned(attribute, toView: nil, gap: 0, relatedBy: relation)
}


public func isPinned<T:UIView>(_ attribute: NSLayoutConstraint.Attribute, gap: CGFloat, priority: UILayoutPriority = UILayoutPriority.required, relatedBy relation: NSLayoutConstraint.Relation = .equal) -> Matcher<T> {
	return isPinned(attribute, toView: nil, gap: gap, priority: priority, relatedBy: relation)
}

public func isPinned<T:UIView>(_ attribute: NSLayoutConstraint.Attribute, withGuide guide: UILayoutSupport, priority: UILayoutPriority = UILayoutPriority.required) -> Matcher<T> {
	return isPinned(attribute, to: guide, priority: priority)
}

public func isPinned<T:UIView>(_ attribute: NSLayoutConstraint.Attribute, to: AnyObject?, gap: CGFloat, priority: UILayoutPriority = UILayoutPriority.required) -> Matcher<T> {
	return Matcher("view is pinned \(descriptionOfAttribute(attribute)) to its superview") {
		(value: T) -> MatchResult in
		return hasMatchingConstraint(value, to: to, attribute: attribute, gap: gap, priority: priority)
	}
}

public func isPinned<T:UIView>(_ attribute: NSLayoutConstraint.Attribute, to: AnyObject?, priority: UILayoutPriority = UILayoutPriority.required) -> Matcher<T> {
	return isPinned(attribute, to: to, gap: 0, priority: priority)
}


public func isPinnedToAllEdges<T:UIView>(gap: CGFloat = 0) -> Matcher<T> {
	return allOf(
			isPinned(.leading, gap: gap),
			isPinned(.trailing, gap: gap),
			isPinned(.top, gap: gap),
			isPinned(.bottom, gap: gap)
	)
}

public func descriptionOfAttribute(_ attribute:NSLayoutConstraint.Attribute) -> String {
	switch attribute {
	case .left:
		return "Left"
	case .right:
		return "Right"
	case .top:
		return "Top"
	case .bottom:
		return "Bottom"
	case .leading:
		return "Leading"
	case .trailing:
		return "Trailing"
	case .width:
		return "Width"
	case .height:
		return "Height"
	case .centerX:
		return "CenterX"
	case .centerY:
		return "CenterY"
	case .lastBaseline:
		return "Baseline"
	case .firstBaseline:
		return "FirstBaseline"
	case .leftMargin:
		return "LeftMargin"
	case .rightMargin:
		return "RightMargin"
	case .topMargin:
		return "TopMargin"
	case .bottomMargin:
		return "BottomMargin"
	case .leadingMargin:
		return "LeadingMargin"
	case .trailingMargin:
		return "TrailingMargin"
	case .centerXWithinMargins:
		return "CenterXWithinMargins"
	case .centerYWithinMargins:
		return "CenterYWithinMargins"
	case .notAnAttribute:
		return "NotAnAttribute"
	default:
		return "unknown"
	}
}

func inverseAttribute(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint.Attribute {
	switch (attribute) {
	case .top:
		return .bottom;
	case .bottom:
		return .top;
	case .right:
		return .left;
	case .left:
		return .right;
	case .leading:
		return .trailing
	case .trailing:
		return .leading
	default:
		return attribute;
	}
}

func swap(_ first: inout Any, _ second: inout Any) {
	let tmp = first
	second = first
	first = tmp
}

