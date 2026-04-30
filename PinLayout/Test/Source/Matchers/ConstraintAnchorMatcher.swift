//
// Created by René Pirringer
//

import Foundation
import Hamcrest
import UIKit
@testable import PinLayout


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


private func hasAnchorConstraint(for view: UIView, baseView: UIView?, attribute: NSLayoutConstraint.Attribute, guide: Layout.Guide, constant: CGFloat = 0) -> MatchResult {
	if #available(iOS 9, *) {
		if let baseView, let layoutGuide = baseView.guide(guide) {
			return hasAnchorConstraint(for: view, baseView: baseView, attribute: attribute, guide: layoutGuide, constant: constant)
		}
	}
	return .mismatch(nil)
}



public func isPinnedToSafeAreaAnchor<T: UIView>(_ attribute: NSLayoutConstraint.Attribute, gap: CGFloat = 0) -> Matcher<T> {
	return isPinned(attribute, guide: .safeArea, gap: gap)
}

public func isPinnedToReadableAnchor<T: UIView>(_ attribute: NSLayoutConstraint.Attribute, gap: CGFloat = 0) -> Matcher<T> {
	return isPinned(attribute, guide: .readable, gap: gap)
}

public func isPinned<T: UIView>(_ attribute: NSLayoutConstraint.Attribute, guide: Layout.Guide, gap: CGFloat = 0) -> Matcher<T> {
	return Matcher("view has \(attribute) anchor for safe area") {
		(value: T) -> MatchResult in
		return hasAnchorConstraint(for: value, baseView: value.superview, attribute: attribute, guide: guide, constant: attribute.constantValue(-gap))
	}
}
