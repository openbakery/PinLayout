//
// Created by Rene Pirringer on 01.08.16.
//

import Foundation
import XCTest
import Hamcrest
@testable import PinLayout


class PinLayoutTest: PinLayout_Base_Test {


	func testPinEdgeTopWithToView() {
		let superView = UIView()
		superView.addSubview(view)
		superView.addSubview(toView)

		pinLayout.pin(view:view, to: .top, of: toView)

		assertThat(superView.constraints, presentAnd(hasCount(1)))

		self.checkConstraintWithInverse(.top, onView: superView)
	}


	func testPinEdgeTop() {
		toView.addSubview(view)
		pinLayout.pin(view:view, to:.top, of:toView)

		assertThat(toView.constraints, hasCount(1))
		self.checkConstraint(.top)
	}


	func testPinEdgeBottom() {
		toView.addSubview(view)
		pinLayout.pin(view:view, to: .bottom, of: toView)

		assertThat(toView.constraints, hasCount(1))
		self.checkConstraint(.bottom)
	}


	func testPinEdgeLeft() {
		toView.addSubview(view)
		pinLayout.pin(view:view, to: .left, of: toView)

		assertThat(toView.constraints, hasCount(1))
		self.checkConstraint(.left)
	}

	func testPinEdgeRight() {
		toView.addSubview(view)
		pinLayout.pin(view:view, to: .right, of: toView)

		assertThat(toView.constraints, hasCount(1))
		self.checkConstraint(.right)
	}

	func testPinToAllEdges() {
		toView.addSubview(view)
		pinLayout.pinToAllEdges(view: view, of: toView)

		assertThat(toView.constraints, hasCount(4))
		self.checkConstraint(.top)
		self.checkConstraint(.bottom)
		self.checkConstraint(.leading)
		self.checkConstraint(.trailing)
	}



	func assertThatFirstItemOf(_ constraint: NSLayoutConstraint, equalToView: UIView) {
		assertThat(constraint.firstItem, present())
		if let firstItemView = constraint.firstItem as? UIView {
			assertThat(firstItemView, equalTo(equalToView))
		} else {
			XCTFail("firstItem is not a UIView")
		}
	}

	func assertThatSecondItemOf(_ constraint: NSLayoutConstraint, equalToView: UIView) {
		assertThat(constraint.secondItem, present())
		if let secondItemView = constraint.secondItem as? UIView {
			assertThat(secondItemView, equalTo(equalToView))
		} else {
			XCTFail("secondItem is not a UIView")
		}
	}

	func testSetWidthAndHeightEqualOfView() {
		toView.addSubview(view)
		pinLayout.setEqualWidthAndHeight(view:view)
		assertThat(view.constraints, hasCount(1))

		if (view.constraints.count == 0) {
			// avoid that the test crashes
			return
		}

		let constraint = view.constraints[0]
		assertThat(constraint.constant, equalTo(0))
		assertThat(constraint.firstAttribute, equalTo(.width))
		assertThat(constraint.secondAttribute, equalTo(.height))

		assertThatFirstItemOf(constraint, equalToView:view)
		assertThatSecondItemOf(constraint, equalToView:view)

		assertThat(constraint.relation, equalTo(.equal))
	}


	func testPinEdgeBaseLineTop() {
		toView.addSubview(view)
		pinLayout.pin(view:view, to: .topBaseline, of: toView)

		assertThat(toView.constraints, hasCount(1))
		self.checkConstraintWithFirstAttribute(.firstBaseline, andSecond: .top)
	}

	func constraintAtIndex(_ index: Int, ofView:UIView) -> NSLayoutConstraint {
		if (ofView.constraints.count > index) {
			return ofView.constraints[index]
		}
		XCTFail("there is no constraint a index: \(index)")
		// return something to make the compiler happy
		return NSLayoutConstraint(item: ofView, attribute:.top, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0.0)
	}

	func testPinEdgeBaseLineBottom() {
		toView.addSubview(view)
		pinLayout.pin(view:view, to: .bottomBaseline, of: toView)

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

		pinLayout.setMinHeight(of: view, to: 44.0)

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

		pinLayout.setMinWidth(of: view, to: 144.0)

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

		pinLayout.setHeight(of:view, to: 44.0)

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

		pinLayout.setWidth(of:view, to: 144.0)

		assertThat(view.constraints, hasCount(1))

		let constraint = constraintAtIndex(0, ofView:view)
		assertThat(constraint.constant, equalTo(144.0))
		assertThat(constraint.firstAttribute, equalTo(.width))
		assertThat(constraint.secondAttribute, equalTo(.notAnAttribute))

		assertThatFirstItemOf(constraint, equalToView: view)
		assertThat(constraint.secondItem, nilValue())

		assertThat(constraint.relation, equalTo(.equal))
	}


	func testVerticalCenterView() {
		toView.addSubview(view)

		pinLayout.equalCenterY(view:view)

		assertThat(toView.constraints, hasCount(1))

		let constraint = constraintAtIndex(0, ofView:toView)
		assertThat(constraint.constant, equalTo(0.0))
		assertThat(constraint.firstAttribute, equalTo(.centerY))
		assertThat(constraint.secondAttribute, equalTo(.centerY))

		assertThatFirstItemOf(constraint, equalToView: view)
		assertThatSecondItemOf(constraint, equalToView: toView)

		assertThat(constraint.relation, equalTo(.equal))

	}


	func testHorizontalCenterView() {
		toView.addSubview(view)

		pinLayout.equalCenterX(view:view)

		assertThat(toView.constraints, hasCount(1))

		let constraint = constraintAtIndex(0, ofView:toView)
		assertThat(constraint.constant, equalTo(0.0))
		assertThat(constraint.firstAttribute, equalTo(.centerX))
		assertThat(constraint.secondAttribute, equalTo(.centerX))

		assertThatFirstItemOf(constraint, equalToView: view)
		assertThatSecondItemOf(constraint, equalToView: toView)

		assertThat(constraint.relation, equalTo(.equal))
	}


	func test_equalCenter_View() {
		toView.addSubview(view)

		pinLayout.equalCenter(view:view)

		assertThat(toView.constraints, hasCount(2))

		let constraintY = constraintAtIndex(0, ofView: toView)
		assertThat(constraintY.constant, equalTo(0.0))
		assertThat(constraintY.firstAttribute, equalTo(.centerY))
		assertThat(constraintY.secondAttribute, equalTo(.centerY))

		let constraintX = constraintAtIndex(1, ofView: toView)
		assertThat(constraintX.constant, equalTo(0.0))
		assertThat(constraintX.firstAttribute, equalTo(.centerX))
		assertThat(constraintX.secondAttribute, equalTo(.centerX))
	}


	func testHorizontalCenterTwoView() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		pinLayout.equalCenterX(view:view, toView: secondView)

		assertThat(toView.constraints, hasCount(1))

		let constraint = constraintAtIndex(0, ofView:toView)
		assertThat(constraint.constant, equalTo(0.0))
		assertThat(constraint.firstAttribute, equalTo(.centerX))
		assertThat(constraint.secondAttribute, equalTo(.centerX))

		assertThatFirstItemOf(constraint, equalToView: view)
		assertThatSecondItemOf(constraint, equalToView: secondView)

		assertThat(constraint.relation, equalTo(.equal))
	}

	func testVerticalCenterTwoView() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		pinLayout.equalCenterY(view:view, toView: secondView)

		assertThat(toView.constraints, hasCount(1))

		let constraint = constraintAtIndex(0, ofView:toView)
		assertThat(constraint.constant, equalTo(0.0))
		assertThat(constraint.firstAttribute, equalTo(.centerY))
		assertThat(constraint.secondAttribute, equalTo(.centerY))

		assertThatFirstItemOf(constraint, equalToView: view)
		assertThatSecondItemOf(constraint, equalToView: secondView)

		assertThat(constraint.relation, equalTo(.equal))
	}


	func testCenterViewWithTwoViews() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		pinLayout.equalCenter(view:view, with: secondView)

		assertThat(toView.constraints, hasCount(2))

		let constraintY = constraintAtIndex(0, ofView: toView)
		assertThat(constraintY.constant, equalTo(0.0))
		assertThat(constraintY.firstAttribute, equalTo(.centerY))
		assertThat(constraintY.secondAttribute, equalTo(.centerY))

		let constraintX = constraintAtIndex(1, ofView: toView)
		assertThat(constraintX.constant, equalTo(0.0))
		assertThat(constraintX.firstAttribute, equalTo(.centerX))
		assertThat(constraintX.secondAttribute, equalTo(.centerX))
	}



	func testTwoViewWithSameWidth() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		pinLayout.setEqualConstant(view: view, andView: secondView, attribute: .width)

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

		pinLayout.setEqualConstant(view: view, andView: secondView, attribute: .height)

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

		pinLayout.setEqualConstant(view: view, andView: secondView, attribute: .height, priority:UILayoutPriority(rawValue: 100), multiplier: 1.0)

		assertThat(toView.constraints, hasCount(1))
		if (toView.constraints.count > 0) {
			let constraint = constraintAtIndex(0, ofView: toView)
			assertThat(constraint.priority.rawValue, equalTo(100))
		}

	}

	func testViewsHaveSameHeight() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		pinLayout.setEqualHeight(view: view, andView:secondView)

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

		pinLayout.setEqualHeight(view: view, andView:secondView, priority:UILayoutPriority(rawValue: 101))

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

		pinLayout.setEqualWidth(view: view, andView:secondView)

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

		pinLayout.setEqualWidth(view: view, andView:secondView, priority:UILayoutPriority(rawValue: 101))

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


		let constraint = pinLayout.findConstraintForView(view, attribute:.height)
		assertThat(constraint, present())
		if let constraintUnwrapped = constraint {
			assertThat(constraintUnwrapped.firstAttribute, equalTo(.height))
			assertThat(constraintUnwrapped.secondAttribute, equalTo(.notAnAttribute))
			assertThat(constraintUnwrapped.constant, equalTo(44.0))
		}
	}

	func test_pinView_to_bottom_with_relation() {
		toView.addSubview(view)
		let constraint = pinLayout.pin(view:view, to: .bottom, relatedBy: .greaterThanOrEqual)
		assertThat(constraint?.relation, presentAnd(equalTo(.greaterThanOrEqual)))
	}


	func test_remove_height_constraint_should_remove_it() {
		toView.addSubview(view)
		pinLayout.setHeight(of:view, to: 44.0)
		assertThat(view.constraints, hasCount(1))

		pinLayout.removeAllConstraints(from: view)
		assertThat(view.constraints, hasCount(0))
	}

	func test_remove_pin_constraints_should_remove_it() {
		toView.addSubview(view)
		pinLayout.pinToAllEdges(view: view)
		assertThat(toView.constraints, hasCount(4))

		pinLayout.removeAllConstraints(from: view)
		assertThat(toView.constraints, hasCount(0))
	}

	func test_record_constraints_records_pin_constraints() {
		pinLayout.startRecord()

		toView.addSubview(view)
		pinLayout.pinToAllEdges(view: view)
		let constraints = pinLayout.finishRecord()
		assertThat(constraints, hasCount(4))
	}
	
	func test_record_constraints_and_finish_resets_recorded_constraints() {
		pinLayout.startRecord()
		toView.addSubview(view)
		pinLayout.pinToAllEdges(view: view)
		let constraints = pinLayout.finishRecord()
		assertThat(constraints, hasCount(4))
		assertThat(pinLayout.finishRecord(), hasCount(0))
	}


	func test_record_constraints_and_start_a_second_time_returns_only_the_new() {
		pinLayout.startRecord()
		toView.addSubview(view)
		pinLayout.pinToAllEdges(view: view)
		pinLayout.startRecord()
		pinLayout.pinToAllEdges(view: view)
		assertThat(pinLayout.finishRecord(), hasCount(4))
	}

	func test_record_setHeight_constraint() {
		pinLayout.startRecord()
		toView.addSubview(view)
		pinLayout.setHeight(of: view, to: 10)
		assertThat(pinLayout.finishRecord(), hasCount(1))
	}

	func test_record_equal_constraint() {
		pinLayout.startRecord()
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)
		pinLayout.setEqualHeight(view: view, andView: secondView)
		assertThat(pinLayout.finishRecord(), hasCount(1))
	}

	func test_record_equalWidthAndHeight_constraint() {
		pinLayout.startRecord()
		toView.addSubview(view)
		pinLayout.setEqualWidthAndHeight(view: view)
		assertThat(pinLayout.finishRecord(), hasCount(1))
	}

	func test_record_pinWithGuide_constraint() {
		pinLayout.startRecord()
		let viewController = UIViewController()
		show(viewController:viewController)
		viewController.view.addSubview(view)
		pinLayout.pin(view: view, to: .top)
		assertThat(pinLayout.finishRecord(), hasCount(1))
	}



	@available(iOS 11, *)
	func test_pin_leading_with_safeGuide() {
		toView.addSubview(view)
		pinLayout.pin(view:view, to:.leadingSafeArea)
		assertThat(view, isPinnedToSafeAreaAnchor(.leading))
		assertThat(view, not(isPinned(.leading)))
	}
	
	@available(iOS 11, *)
	func test_pin_leading_with_safeGuide_and_gap() {
		toView.addSubview(view)
		if let constraint = pinLayout.pin(view:view, to:.leadingSafeArea) {
			constraint.constant = 200
		}
		assertThat(view, isPinnedToSafeAreaAnchor(.leading, gap: 200))
		assertThat(view, not(isPinned(.leading)))
	}
	

	@available(iOS 11, *)
	func test_pin_trailing_with_safeGuide() {
		toView.addSubview(view)
		pinLayout.pin(view:view, to:.trailingSafeArea)
		assertThat(view, isPinnedToSafeAreaAnchor(.trailing))
		assertThat(view, not(isPinned(.trailing)))
	}

	@available(iOS 11, *)
	func test_pin_top_with_safeGuide() {
		toView.addSubview(view)
		pinLayout.pin(view:view, to:.topSafeArea)
		assertThat(view, isPinnedToSafeAreaAnchor(.top))
		assertThat(view, not(isPinned(.top)))
	}

	@available(iOS 11, *)
	func test_pin_bottom_with_safeGuide() {
		toView.addSubview(view)
		pinLayout.pin(view:view, to:.bottomSafeArea)
		assertThat(view, isPinnedToSafeAreaAnchor(.bottom))
		assertThat(view, not(isPinned(.bottom)))
	}



	func test_record_pin_with_safeGuide_constraint() {
		pinLayout.startRecord()
		let viewController = UIViewController()
		show(viewController:viewController)
		viewController.view.addSubview(view)
		pinLayout.pin(view: view, to: .leadingSafeArea)
		assertThat(pinLayout.finishRecord(), hasCount(1))
	}



	func test_align_views_to_top() {
		let superView = UIView()

		superView.addSubview(view)
		superView.addSubview(toView)

		pinLayout.align(view: view, with: toView, to: .top)

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

		pinLayout.align(view: view, with: toView, to: .left)

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

		pinLayout.align(view: view, with: toView, to: .trailing, gap: 100)

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
		
		pinLayout.pin(view: view, to: .top, of: toView, gap: 10)
		
		assertThat(view, isPinned(.top, toView: toView, gap: 10))
	}

	func test_is_pinned_to_view_with_gap_matcher() {
		let superView = UIView()
		superView.addSubview(view)
		superView.addSubview(toView)
		
		let constraint = pinLayout.pin(view: view, to: .top, of: toView, gap: 10)

		
		// then
		assertThat(constraint?.constant, presentAnd(equalTo(10)))
		assertThat(constraint?.firstAttribute, equalTo(.top))
		
		assertThat(constraint?.firstItem, presentAnd(instanceOf(UIView.self, and:equalTo(view))))
		assertThat(constraint?.secondAttribute, presentAnd(equalTo(.bottom)))
		assertThat(constraint?.secondItem, presentAnd(instanceOf(UIView.self, and:equalTo(toView))))
	}

	
}
