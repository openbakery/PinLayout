//
//  ConstraintEqualMatcher.swift
//
//  Created by Rene Pirringer
//

import Foundation
import Hamcrest
import UIKit


private func hasMatchingEqualConstraint(_ view: UIView, attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0) -> MatchResult {
	return hasMatchingEqualConstraint(view, to: view.superview, attribute: attribute, constant: constant)
}


private func hasMatchingEqualConstraint(_ view: UIView, to toView: UIView?, attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0) -> MatchResult {

	if let superView = findSuperView(view, toView) {
		var secondItem = toView
		if secondItem == nil {
			secondItem = superView
		}

		for constraint in superView.constraints {

			if (constraint.firstItem === view &&
					constraint.secondItem === secondItem &&
					constraint.firstAttribute == attribute &&
					constraint.secondAttribute == attribute &&
					constraint.relation == NSLayoutConstraint.Relation.equal &&
					constraint.constant == constant &&
					constraint.isActive) {
				return .match
			}

			if (constraint.firstItem === secondItem &&
					constraint.secondItem === view &&
					constraint.firstAttribute == attribute &&
					constraint.secondAttribute == attribute &&
					constraint.relation == NSLayoutConstraint.Relation.equal &&
					constraint.constant == CGFloat(constant) &&
					constraint.isActive) {
				return .match
			}

		}
	}

	return .mismatch(nil)
}


private func hasMatchingEqualConstraint(_ view: UIView, secondView: UIView?, firstAttribute: NSLayoutConstraint.Attribute, secondAttribute: NSLayoutConstraint.Attribute) -> MatchResult {
	return hasMatchingEqualConstraint(view, secondView: secondView, firstAttribute: firstAttribute, secondAttribute: secondAttribute, multiplier: 1.0)
}

private func hasMatchingEqualConstraint(_ view: UIView, secondView: UIView?, firstAttribute: NSLayoutConstraint.Attribute, secondAttribute: NSLayoutConstraint.Attribute, multiplier: CGFloat) -> MatchResult {


	if let superView = view.superview {

		let firstItem = view
		var secondItem: UIView
		var viewWithConstraints = firstItem

		if let second = secondView {
			secondItem = second
			viewWithConstraints = superView
		} else {
			secondItem = firstItem
			viewWithConstraints = firstItem
		}

		for constraint in viewWithConstraints.constraints {

			if (constraint.firstItem === view &&
					constraint.secondItem === secondItem &&
					constraint.firstAttribute == firstAttribute &&
					constraint.secondAttribute == secondAttribute &&
					constraint.relation == NSLayoutConstraint.Relation.equal &&
					constraint.multiplier == CGFloat(multiplier) &&
					constraint.constant == 0 &&
					constraint.isActive) {
				return .match
			}

			if (constraint.firstItem === secondItem &&
					constraint.secondItem === view &&
					constraint.firstAttribute == firstAttribute &&
					constraint.secondAttribute == secondAttribute &&
					constraint.relation == NSLayoutConstraint.Relation.equal &&
					constraint.multiplier == CGFloat(multiplier) &&
					constraint.constant == 0 &&
					constraint.isActive) {
				return .match
			}

		}
	}

	return .mismatch(nil)

}


public func hasEqualConstraint<T: UIView>(_ attribute: NSLayoutConstraint.Attribute, withConstant constant: CGFloat = 0) -> Matcher<T> {
	return Matcher("view has equal constraint: \(descriptionOfAttribute(attribute))") {
		(value: T) -> MatchResult in
		return hasMatchingEqualConstraint(value, attribute: attribute, constant: constant)
	}
}

public func hasEqualConstraint<T: UIView>(_ attribute: NSLayoutConstraint.Attribute, with view: UIView, constant: CGFloat = 0) -> Matcher<T> {
	return Matcher("view has equal constraint: \(descriptionOfAttribute(attribute))") {
		(value: T) -> MatchResult in
		return hasMatchingEqualConstraint(value, to: view, attribute: attribute, constant: constant)
	}
}

public func isVerticalCenter<T: UIView>() -> Matcher<T> {
	return hasEqualConstraint(.centerY)
}

public func isVerticalCenter<T: UIView>(offset: CGFloat) -> Matcher<T> {
	return hasEqualConstraint(.centerY, withConstant: offset)
}

public func isVerticalCenter<T: UIView>(with view: UIView, offset: CGFloat = 0) -> Matcher<T> {
	return hasEqualConstraint(.centerY, with: view, constant: offset)
}

public func isHorizontalCenter<T: UIView>() -> Matcher<T> {
	return hasEqualConstraint(.centerX)
}

public func isHorizontalCenter<T: UIView>(offset: CGFloat) -> Matcher<T> {
	return hasEqualConstraint(.centerX, withConstant: offset)
}

public func isHorizontalCenter<T: UIView>(with view: UIView, offset: CGFloat = 0) -> Matcher<T> {
	return hasEqualConstraint(.centerX, with: view, constant: offset)
}

public func isCenter<T: UIView>() -> Matcher<T> {
	return allOf(isHorizontalCenter(), isVerticalCenter())
}

public func hasSameSize<T: UIView>() -> Matcher<T> {
	return Matcher("view has same size") {
		(value: T) -> MatchResult in
		return hasMatchingEqualConstraint(value, secondView: nil, firstAttribute: .width, secondAttribute: .height)
	}
}

public func hasSameWidthAndHeight<T: UIView>() -> Matcher<T> {
	return Matcher("view has same width and height") {
		(value: T) -> MatchResult in
		return hasMatchingEqualConstraint(value, secondView: nil, firstAttribute: .width, secondAttribute: .height)
	}
}

public func hasSameWidthAs<T: UIView>(_ view: UIView) -> Matcher<T> {
	return hasSameWidthAs(view, multiplier: 1.0)
}

public func hasSameWidthAs<T: UIView>(_ view: UIView, multiplier: CGFloat) -> Matcher<T> {
	return Matcher("view has same size") {
		(value: T) -> MatchResult in
		return hasMatchingEqualConstraint(value, secondView: view, firstAttribute: .width, secondAttribute: .width, multiplier: multiplier)
	}
}

public func hasSameHeightAs<T: UIView>(_ view: UIView) -> Matcher<T> {
	return Matcher("view has same size") {
		(value: T) -> MatchResult in
		return hasMatchingEqualConstraint(value, secondView: view, firstAttribute: .height, secondAttribute: .height)
	}
}


public func hasSameHeightAs<T: UIView>(_ view: UIView, multiplier: CGFloat) -> Matcher<T> {
	return Matcher("view has same size") {
		(value: T) -> MatchResult in
		return hasMatchingEqualConstraint(value, secondView: view, firstAttribute: .height, secondAttribute: .height, multiplier: multiplier)
	}
}

