//
// Created by René Pirringer.
// Copyright (c) 2022 org.openbakery. All rights reserved.
//

import Foundation
import UIKit
import XCTest
import Hamcrest
@testable import PinLayout

class LayoutBuilder_Test: PinLayout_Base_Test {


	func test_pin_to_edge() {
		let superView = UIView()
		superView.addSubview(view)
		superView.addSubview(toView)

		// when
		view.layout.pin(.top, to: toView)

		// then
		assertThat(superView.constraints, presentAnd(hasCount(1)))
		self.checkConstraintWithInverse(.top, onView: superView)
	}


	func testPinEdgeTop() {
		toView.addSubview(view)

		// when
		view.layout.pin(.top, to:toView)

		// then
		assertThat(toView.constraints, hasCount(1))
		self.checkConstraint(.top)
	}

	func testPinEdgeBottom() {
		toView.addSubview(view)

		// when
		view.layout.pin(.bottom, to: toView)

		// the
		assertThat(toView.constraints, hasCount(1))
		self.checkConstraint(.bottom)
	}


	func testPinEdgeLeft() {
		toView.addSubview(view)

		// when
		view.layout.pin(.left, to: toView)

		// then
		assertThat(toView.constraints, hasCount(1))
		self.checkConstraint(.left)
	}


	func testPinToAllEdges() {
		toView.addSubview(view)

		// when
		view.layout.fill()

		// then
		assertThat(toView.constraints, hasCount(4))
		self.checkConstraint(.top)
		self.checkConstraint(.bottom)
		self.checkConstraint(.leading)
		self.checkConstraint(.trailing)
	}


	func testPinEdgeBaseLineTop() {
		toView.addSubview(view)

		// when
		view.layout.pin(.topBaseline, to: toView)

		// then
		assertThat(toView.constraints, hasCount(1))
		self.checkConstraintWithFirstAttribute(.firstBaseline, andSecond: .top)
	}

	func testPinEdgeBaseLineBottom() {
		toView.addSubview(view)

		// thwn
		view.layout.pin(.bottomBaseline, to: toView)

		// then
		assertThat(toView.constraints, hasCount(1))
		let constraint = constraintAtIndex(0, ofView:toView)

		assertThat(constraint.constant, equalTo(0))
		assertThat(constraint.firstAttribute, equalTo(.bottom))
		assertThat(constraint.secondAttribute, equalTo(.lastBaseline))

		assertThatFirstItemOf(constraint, equalToView: view.superview!)
		assertThatSecondItemOf(constraint, equalToView: view)
	}


	func testMinHeight() {
		toView.addSubview(view)

		// when
		view.layout.minHeight(44.0)

		// then
		assertThat(view.constraints, hasCount(1))

		let constraint = constraintAtIndex(0, ofView:view)
		assertThat(constraint.constant, equalTo(44.0))
		assertThat(constraint.firstAttribute, equalTo(.height))
		assertThat(constraint.secondAttribute, equalTo(.notAnAttribute))

		assertThatFirstItemOf(constraint, equalToView: view)
		assertThat(constraint.secondItem, nilValue())

		assertThat(constraint.relation, equalTo(.greaterThanOrEqual))
	}

	func testMinWidth() {
		toView.addSubview(view)

		// when
		view.layout.minWidth(144.0)

		// then
		assertThat(view.constraints, hasCount(1))

		let constraint = constraintAtIndex(0, ofView:view)
		assertThat(constraint.constant, equalTo(144.0))
		assertThat(constraint.firstAttribute, equalTo(.width))
		assertThat(constraint.secondAttribute, equalTo(.notAnAttribute))

		assertThatFirstItemOf(constraint, equalToView: view)
		assertThat(constraint.secondItem, nilValue())

		assertThat(constraint.relation, equalTo(.greaterThanOrEqual))
	}


	func testHeight() {
		toView.addSubview(view)

		// when
		view.layout.height(44)

		// then
		assertThat(view.constraints, hasCount(1))

		let constraint = constraintAtIndex(0, ofView:view)
		assertThat(constraint.constant, equalTo(44.0))
		assertThat(constraint.firstAttribute, equalTo(.height))
		assertThat(constraint.secondAttribute, equalTo(.notAnAttribute))
		assertThatFirstItemOf(constraint, equalToView: view)
		assertThat(constraint.secondItem, nilValue())
		assertThat(constraint.relation, equalTo(.equal))
	}

	func testWidth() {
		toView.addSubview(view)

		// when
		view.layout.width(144)

		// then
		assertThat(view.constraints, hasCount(1))

		let constraint = constraintAtIndex(0, ofView:view)
		assertThat(constraint.constant, equalTo(144.0))
		assertThat(constraint.firstAttribute, equalTo(.width))
		assertThat(constraint.secondAttribute, equalTo(.notAnAttribute))

		assertThatFirstItemOf(constraint, equalToView: view)
		assertThat(constraint.secondItem, nilValue())

		assertThat(constraint.relation, equalTo(.equal))
	}

	func test_view_is_horizontal_center() {
		let superview = UIView()
		superview.addSubview(view)

		let constraint = view.layout.centerX()

		// then
		assertThat(constraint, present())
		assertThat(constraint?.firstAttribute, equalTo(.centerX))
		assertThat(constraint?.firstItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(view.safeAreaLayoutGuide))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.centerX)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(superview.safeAreaLayoutGuide))))
		assertThat(constraint?.constant, presentAnd(equalTo(0)))
		assertThat(constraint?.isActive, presentAnd(equalTo(true)))
		assertThat(view.translatesAutoresizingMaskIntoConstraints, equalTo(false))
	}


	func test_view_is_horizontal_center_with_offset() {
		let superview = UIView()
		superview.addSubview(view)

		let constraint = view.layout.centerX(offset: 20)

		// then
		assertThat(constraint, present())
		assertThat(constraint?.constant, presentAnd(equalTo(20)))
	}

	func test_view_is_horizontal_center_with_other_view() {
		let superview = UIView()
		let other = UIView()
		superview.addSubview(view)
		superview.addSubview(other)

		let constraint = view.layout.centerX(to: other)

		// then
		assertThat(constraint, present())
		assertThat(constraint?.firstAttribute, equalTo(.centerX))
		assertThat(constraint?.firstItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(view.safeAreaLayoutGuide))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.centerX)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(other.safeAreaLayoutGuide))))
		assertThat(constraint?.constant, presentAnd(equalTo(0)))
		assertThat(constraint?.isActive, presentAnd(equalTo(true)))
		assertThat(view.translatesAutoresizingMaskIntoConstraints, equalTo(false))
	}

	// MARK: center Y
	func test_view_is_vertical_center() {
		let superview = UIView()
		superview.addSubview(view)

		let constraint = view.layout.centerY()

		// then
		assertThat(constraint, present())
		assertThat(constraint?.firstAttribute, equalTo(.centerY))
		assertThat(constraint?.firstItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(view.safeAreaLayoutGuide))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.centerY)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(superview.safeAreaLayoutGuide))))
		assertThat(constraint?.constant, presentAnd(equalTo(0)))
		assertThat(constraint?.isActive, presentAnd(equalTo(true)))
		assertThat(view.translatesAutoresizingMaskIntoConstraints, equalTo(false))
	}


	func test_view_is_vertical_center_with_offset() {
		let superview = UIView()
		superview.addSubview(view)

		// when
		let constraint = view.layout.centerY(offset: 20)

		// then
		assertThat(constraint, present())
		assertThat(constraint?.constant, presentAnd(equalTo(20)))
	}


	func test_view_is_vertical_center_with_other_view() {
		let superview = UIView()
		let other = UIView()
		superview.addSubview(view)
		superview.addSubview(other)

		// when
		let constraint = view.layout.centerY(to: other)

		// then
		assertThat(constraint, present())
		assertThat(constraint?.firstAttribute, equalTo(.centerY))
		assertThat(constraint?.firstItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(view.safeAreaLayoutGuide))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.centerY)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(other.safeAreaLayoutGuide))))
		assertThat(constraint?.constant, presentAnd(equalTo(0)))
		assertThat(constraint?.isActive, presentAnd(equalTo(true)))
		assertThat(view.translatesAutoresizingMaskIntoConstraints, equalTo(false))
	}


	// MARK: - safeCenter

	func test_saveArea_center() {
		let superview = UIView()
		superview.addSubview(view)

		// when
		let constraints = view.layout.center()

		// then
		assertThat(constraints, hasCount(2))
		assertThat(constraints.first?.firstAttribute, equalTo(.centerX))
		assertThat(constraints.last?.firstAttribute, equalTo(.centerY))

		assertThat(constraints.first?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(superview.safeAreaLayoutGuide))))
		assertThat(constraints.last?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(superview.safeAreaLayoutGuide))))
	}


	func test_saveArea_center_to_other() {
		let superview = UIView()
		let other = UIView()
		superview.addSubview(view)
		superview.addSubview(other)

		let constraints = view.layout.center(to: other)

		// then
		assertThat(constraints, hasCount(2))
		assertThat(constraints.first?.firstAttribute, equalTo(.centerX))
		assertThat(constraints.last?.firstAttribute, equalTo(.centerY))

		assertThat(constraints.first?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(other.safeAreaLayoutGuide))))
		assertThat(constraints.last?.secondItem, presentAnd(instanceOf(UILayoutGuide.self, and:equalTo(other.safeAreaLayoutGuide))))
	}


	func testTwoViewWithSameWidth() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		// when
		view.layout.equalWidth(with: secondView)

		// then
		assertThat(toView.constraints, hasCount(1))
		if (toView.constraints.count > 0) {
			let constraint = constraintAtIndex(0, ofView: toView)
			assertThat(constraint.constant, equalTo(0.0))
			assertThat(constraint.firstAttribute, equalTo(.width))
			assertThat(constraint.secondAttribute, equalTo(.width))

			assertThatFirstItemOf(constraint, equalToView: view)
			assertThatSecondItemOf(constraint, equalToView: secondView)
		}

	}

	func testTwoViewWithSameHeight() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		// when
		view.layout.equalHeight(with: secondView)

		assertThat(toView.constraints, hasCount(1))
		if (toView.constraints.count > 0) {
			let constraint = constraintAtIndex(0, ofView: toView)
			assertThat(constraint.constant, equalTo(0.0))
			assertThat(constraint.firstAttribute, equalTo(.height))
			assertThat(constraint.secondAttribute, equalTo(.height))

			assertThatFirstItemOf(constraint, equalToView: view)
			assertThatSecondItemOf(constraint, equalToView: secondView)
		}

	}

	func testTwoViewWithSameHeightWithPriority() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		// when
		view.layout.equalHeight(with: secondView, priority:UILayoutPriority(rawValue: 100))

		assertThat(toView.constraints, hasCount(1))
		if (toView.constraints.count > 0) {
			let constraint = constraintAtIndex(0, ofView: toView)
			assertThat(constraint.priority.rawValue, equalTo(100))
			assertThat(constraint.multiplier, equalTo(1.0))
		}

	}

	func testViewsHaveSameHeight() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)


		// when
		view.layout.equalHeight(with: secondView)

		assertThat(toView.constraints, hasCount(1))
		if (toView.constraints.count > 0) {
			let constraint = constraintAtIndex(0, ofView: toView)
			assertThat(constraint.constant, equalTo(0.0))
			assertThat(constraint.firstAttribute, equalTo(.height))
			assertThat(constraint.secondAttribute, equalTo(.height))

			assertThatFirstItemOf(constraint, equalToView: view)
			assertThatSecondItemOf(constraint, equalToView: secondView)
		}
	}

	func testViewsHaveSameHeightWithPriority() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		// when
		view.layout.equalHeight(with: secondView, priority:UILayoutPriority(rawValue: 101))

		// then
		assertThat(toView.constraints, hasCount(1))
		if (toView.constraints.count > 0) {
			let constraint = constraintAtIndex(0, ofView: toView)
			assertThat(constraint.priority.rawValue, equalTo(101))
		}
	}


	func testViewsHaveSameWidth() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		// when
		view.layout.equalWidth(with: secondView)

		assertThat(toView.constraints, hasCount(1))
		if (toView.constraints.count > 0) {
			let constraint = constraintAtIndex(0, ofView: toView)
			assertThat(constraint.constant, equalTo(0.0))
			assertThat(constraint.firstAttribute, equalTo(.width))
			assertThat(constraint.secondAttribute, equalTo(.width))

			assertThatFirstItemOf(constraint, equalToView: view)
			assertThatSecondItemOf(constraint, equalToView: secondView)		}
	}

	func testViewsHaveSameWidthWithPriority() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		// when
		view.layout.equalWidth(with: secondView, priority:UILayoutPriority(rawValue: 101))

		// then
		assertThat(toView.constraints, hasCount(1))
		if (toView.constraints.count > 0) {
			let constraint = constraintAtIndex(0, ofView: toView)
			assertThat(constraint.priority.rawValue, equalTo(101))
		}
	}

	func testFindConstraint() {
		toView.addSubview(view)

		pinLayout.setHeight(of:view, to: 44.0)
		pinLayout.setWidth(of:view, to: 44.0)

		// when
		let constraint = view.layout.findConstraint(attribute:.height)

		// then
		assertThat(constraint, present())
		if let constraintUnwrapped = constraint {
			assertThat(constraintUnwrapped.firstAttribute, equalTo(.height))
			assertThat(constraintUnwrapped.secondAttribute, equalTo(.notAnAttribute))
			assertThat(constraintUnwrapped.constant, equalTo(44.0))
		}
	}

	func test_pinView_to_bottom_with_relation() {
		//given
		toView.addSubview(view)

		// when
		let constraint = view.layout.pin(.bottom, relatedBy: .greaterThanOrEqual).first

		// then
		assertThat(constraint?.relation, presentAnd(equalTo(.greaterThanOrEqual)))
	}


	func test_remove_height_constraint_should_remove_it() {
		// given
		toView.addSubview(view)
		pinLayout.setHeight(of:view, to: 44.0)
		assertThat(view.constraints, hasCount(1))

		// when
		view.layout.removeAllConstraints()

		// then
		assertThat(view.constraints, hasCount(0))
	}

	func test_remove_pin_constraints_should_remove_it() {
		toView.addSubview(view)
		pinLayout.pinToAllEdges(view: view)
		assertThat(toView.constraints, hasCount(4))

		// when
		view.layout.removeAllConstraints()

		// then
		assertThat(toView.constraints, hasCount(0))
	}


	func test_pin_leading_with_safeGuide() {
		toView.addSubview(view)

		// when
		view.layout.pin(.leadingSafeArea)

		// then
		assertThat(view, isPinnedToSafeAreaAnchor(.leading))
		assertThat(view, not(isPinned(.leading)))
	}

	@available(iOS 11, *)
	func test_pin_leading_with_safeGuide_and_gap() {
		toView.addSubview(view)

		// when
		view.layout.pin(.leadingSafeArea, gap: 200)

		// then
		assertThat(view, isPinnedToSafeAreaAnchor(.leading, gap: 200))
		assertThat(view, not(isPinned(.leading)))
	}

	func test_pin_trailing_with_safeGuide() {
		toView.addSubview(view)

		// when
		view.layout.pin(.trailingSafeArea)

		// then
		assertThat(view, isPinnedToSafeAreaAnchor(.trailing))
		assertThat(view, not(isPinned(.trailing)))
	}


	func test_pin_trailing_with_gap() {
		toView.addSubview(view)

		// when
		view.layout.pin(.trailing, gap: .cellMargin)

		// then
		let constraint = toView.constraints.first
		assertThat(constraint?.constant, presentAnd(equalTo(Layout.Defaults.cellMargin.value)))
	}

	func test_pin_top_with_safeGuide() {
		toView.addSubview(view)

		// when
		view.layout.pin(.topSafeArea)

		// then
		assertThat(view, isPinnedToSafeAreaAnchor(.top))
		assertThat(view, not(isPinned(.top)))
	}

	func test_pin_bottom_with_safeGuide() {
		toView.addSubview(view)

		// when
		view.layout.pin(.bottomSafeArea)

		// then
		assertThat(view, isPinnedToSafeAreaAnchor(.bottom))
		assertThat(view, not(isPinned(.bottom)))
	}


	func test_align_views_to_top() {
		let superView = UIView()

		superView.addSubview(view)
		superView.addSubview(toView)

		// when
		view.layout.align(with: toView, to: .top)

		// then
		let constraint = constraintAtIndex(0, ofView:superView)
		assertThat(constraint.constant, equalTo(0.0))
		assertThat(constraint.firstAttribute, equalTo(.top))
		assertThat(constraint.secondAttribute, equalTo(.top))

		assertThatFirstItemOf(constraint, equalToView: view)
		assertThatSecondItemOf(constraint, equalToView: toView)

		assertThat(constraint.relation, equalTo(.equal))

	}

	func test_align_views_to_left() {
		let superView = UIView()

		superView.addSubview(view)
		superView.addSubview(toView)

		// when
		view.layout.align(with: toView, to: .left)

		// then
		let constraint = constraintAtIndex(0, ofView:superView)
		assertThat(constraint.constant, equalTo(0.0))
		assertThat(constraint.firstAttribute, equalTo(.left))
		assertThat(constraint.secondAttribute, equalTo(.left))

		assertThatFirstItemOf(constraint, equalToView: view)
		assertThatSecondItemOf(constraint, equalToView: toView)

		assertThat(constraint.relation, equalTo(.equal))

	}

	func test_align_views_to_trailing_with_gap() {
		let superView = UIView()
		superView.addSubview(view)
		superView.addSubview(toView)

		// when
		view.layout.align(with: toView, to: .trailing, gap: 100)

		// then

		let constraint = constraintAtIndex(0, ofView:superView)
		assertThat(constraint.firstAttribute, equalTo(.trailing))
		assertThat(constraint.secondAttribute, equalTo(.trailing))
		assertThatFirstItemOf(constraint, equalToView: view)
		assertThatSecondItemOf(constraint, equalToView: toView)
		assertThat(constraint.constant, equalTo(100))
		assertThat(constraint.relation, equalTo(.equal))
	}


	func test_is_pinned_to_view_with_gap() {
		let superView = UIView()
		superView.addSubview(view)
		superView.addSubview(toView)

		// when
		view.layout.pin(.top, to: toView, gap: 10)

		// then
		assertThat(view, isPinned(.top, toView: toView, gap: 10))
	}

	func test_is_pinned_to_view_with_gap_matcher() {
		let superView = UIView()
		superView.addSubview(view)
		superView.addSubview(toView)

		// when
		let constraint = view.layout.pin(.top, to: toView, gap: 10)


		// then
		assertThat(constraint?.constant, presentAnd(equalTo(10)))
		assertThat(constraint?.firstAttribute, equalTo(.top))

		assertThat(constraint?.firstItem, presentAnd(instanceOf(UIView.self, and:equalTo(view))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.bottom)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UIView.self, and:equalTo(toView))))
	}


	func test_is_pinned_to_view_with_gap_default() {
		let superView = UIView()
		superView.addSubview(view)
		superView.addSubview(toView)

		// when
		let constraint = view.layout.pin(.top, to: toView, gap: .margin)


		// then
		assertThat(constraint?.constant, presentAnd(equalTo(8)))
	}

	func test_is_pinned_multiple_to_view_with_gap_default() {
		let superView = UIView()
		superView.addSubview(view)

		// when
		let constraints = view.layout.pin(.top, .bottom, .leading, gap: .margin)


		// then
		for constraint in constraints {
			assertThat(constraint.constant, presentAnd(equalTo(8)))
		}
	}

	func test_set_width_and_height_equal() throws {
		toView.addSubview(view)

		// when
		view.layout.equalWidthAndHeight()

		// then
		assertThat(view.constraints, hasCount(1))

		guard let constraint = view.constraints.first else {
			XCTFail("constraint not present")
			return
		}

		assertThat(constraint.constant, equalTo(0))
		assertThat(constraint.firstAttribute, equalTo(.width))
		assertThat(constraint.secondAttribute, equalTo(.height))


		assertThat(constraint.firstItem, presentAnd(instanceOf(UIView.self, and: equalTo(view))))
		assertThat(constraint.secondItem, presentAnd(instanceOf(UIView.self, and: equalTo(view))))

		assertThat(constraint.relation, equalTo(.equal))
	}
}
