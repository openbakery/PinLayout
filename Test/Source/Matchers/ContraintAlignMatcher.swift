//
// Created by René Pirringer
//

import Foundation
import Hamcrest
import UIKit


private func hasMatchingAlignConstraint(for view: UIView, with otherView: UIView, to attribute: NSLayoutConstraint.Attribute, gap: Float, relatedBy relation: NSLayoutConstraint.Relation = .equal) -> MatchResult {

	if let commonSuperView = findSuperView(view, otherView) {

		if commonSuperView == view || commonSuperView == otherView {
			return .mismatch(nil)
		}

		for constraint in commonSuperView.constraints {

			if (constraint.firstAttribute == attribute &&
					constraint.secondAttribute == attribute &&
					constraint.relation == relation &&
					constraint.constant == CGFloat(gap) &&
					constraint.isActive
				 ) {

				if (constraint.firstItem === view && constraint.secondItem === otherView) {
					return .match
				}
				if (constraint.firstItem === otherView && constraint.secondItem === view) {
					return .match
				}
			}

		}
	}
	return .mismatch(nil)
}


public func isAligned<T: UIView>(with view: UIView, to attribute: NSLayoutConstraint.Attribute, gap: Float = 0) -> Matcher<T> {
	return Matcher("view is pinned \(descriptionOfAttribute(attribute)) to its superview") {
		(value: T) -> MatchResult in
		return hasMatchingAlignConstraint(for: value, with: view, to: attribute, gap: gap)

	}
}

