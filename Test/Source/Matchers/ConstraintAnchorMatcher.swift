//
// Created by René Pirringer
//

import Foundation
import Hamcrest
import UIKit


private func hasAnchorConstraint(for view: UIView, baseView: UIView, attribute: NSLayoutConstraint.Attribute, guide: UILayoutGuide, constant: CGFloat = 0) -> MatchResult {
	let secondItem = view
	for constraint in baseView.constraints {
		if let firstItem = constraint.firstItem as? UILayoutGuide {
			if (constraint.firstAttribute == attribute) {
				if (constraint.secondAttribute == attribute &&
						constraint.secondItem === secondItem &&
						firstItem == guide &&
						constraint.multiplier == 1.0 &&
						constraint.constant == constant &&
						constraint.isActive) {
					return .match
				}
			}
		}
	}
	return .mismatch(nil)
}

private func hasSafeAreaAnchorConstraint(for view: UIView, baseView: UIView?, attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0) -> MatchResult {
	if #available(iOS 11, *) {
		if let baseView = baseView {
			return hasAnchorConstraint(for: view, baseView: baseView, attribute: attribute, guide: baseView.safeAreaLayoutGuide, constant: constant)
		}
	}
	return .mismatch(nil)
}


private func hasReadableAnchorConstraint(for view: UIView, baseView: UIView?, attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0) -> MatchResult {
	if #available(iOS 9, *) {
		if let baseView = baseView {
			return hasAnchorConstraint(for: view, baseView: baseView, attribute: attribute, guide: baseView.readableContentGuide, constant: constant)
		}
	}
	return .mismatch(nil)
}



public func isPinnedToSafeAreaAnchor<T: UIView>(_ attribute: NSLayoutConstraint.Attribute) -> Matcher<T> {
	return Matcher("view has \(attribute) anchor for safe area") {
		(value: T) -> MatchResult in
		return hasSafeAreaAnchorConstraint(for: value, baseView: value.superview, attribute: attribute)
	}
}

public func isPinnedToSafeAreaAnchor<T: UIView>(_ attribute: NSLayoutConstraint.Attribute, gap: Float) -> Matcher<T> {
	return Matcher("view has \(attribute) anchor for safe area") {
		(value: T) -> MatchResult in
		return hasSafeAreaAnchorConstraint(for: value, baseView: value.superview, attribute: attribute, constant: CGFloat(gap))
	}
}


public func isPinnedToReadableAnchor<T: UIView>(_ attribute: NSLayoutConstraint.Attribute) -> Matcher<T> {
	return Matcher("view has \(attribute) anchor for safe area") {
		(value: T) -> MatchResult in
		return hasReadableAnchorConstraint(for: value, baseView: value.superview, attribute: attribute, constant: 0)
	}
}


public func isPinnedToReadableAnchor<T: UIView>(_ attribute: NSLayoutConstraint.Attribute, gap: Float) -> Matcher<T> {
	return Matcher("view has \(attribute) anchor for safe area") {
		(value: T) -> MatchResult in
		return hasReadableAnchorConstraint(for: value, baseView: value.superview, attribute: attribute, constant: CGFloat(-gap))
	}
}