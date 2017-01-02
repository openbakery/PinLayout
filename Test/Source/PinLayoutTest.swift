//
// Created by Rene Pirringer on 01.08.16.
//

import Foundation
import XCTest
import Hamcrest
@testable import PinLayout

class PinLayoutTest: XCTestCase {

	let view = UIView()
	let toView = UIView()
	let layoutHelper = PinLayout()


	@discardableResult func checkConstraint(_ attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
		return self.checkConstraintWithFirstAttribute(attribute, andSecond: attribute)
	}

	@discardableResult func checkConstraintWithFirstAttribute(_ firstAttribute:NSLayoutAttribute, andSecond secondAttribute:NSLayoutAttribute) -> NSLayoutConstraint? {
		return self.checkConstraintWithFirstAttribute(firstAttribute, andSecond:secondAttribute, onView:toView)
	}

	func checkConstraintWithFirstAttribute(_ firstAttribute: NSLayoutAttribute, andSecond secondAttribute: NSLayoutAttribute, onView: UIView) -> NSLayoutConstraint? {

		let constraint = self.constraintOnView(onView, firstAttribute: firstAttribute, secondAttribute: secondAttribute)
		assertThat(constraint, present())

		if let constraintUnwrapped = constraint {
			assertThat(constraintUnwrapped.constant, equalTo(0))

			assertThat(constraintUnwrapped.firstAttribute, equalTo(firstAttribute))
			assertThat(constraintUnwrapped.secondAttribute, equalTo(secondAttribute))

			assertThat(constraintUnwrapped.firstItem, present())
			assertThat(constraintUnwrapped.secondItem, present())

			if let firstItemView = constraintUnwrapped.firstItem as? UIView {
				if (firstAttribute == .bottom || firstAttribute == .right) {
					assertThat(firstItemView, equalTo(toView))
				} else {
					assertThat(firstItemView, equalTo(view))
				}
			}

			if let secondItemView = constraintUnwrapped.secondItem as? UIView {
				if (firstAttribute == .bottom || firstAttribute == .right) {
					assertThat(secondItemView, equalTo(view))
				} else {
					assertThat(secondItemView, equalTo(toView))
				}
			}

		}
		return constraint

	}


@discardableResult func checkConstraintWithInverse(_ attribute: NSLayoutAttribute, onView:UIView) -> NSLayoutConstraint? {
	let constraint = self.constraintWithInverseOnView(onView,  withAttribute:attribute)
	assertThat(constraint, present())

	if let contraintUnwrapped = constraint {
		assertThat(contraintUnwrapped.constant, equalTo(0))
		assertThat(contraintUnwrapped.firstAttribute, equalTo(attribute))
		assertThat(contraintUnwrapped.secondAttribute, equalTo(layoutHelper.inverseAttribute(attribute)))
		assertThat(contraintUnwrapped.firstItem, present())
		assertThat(contraintUnwrapped.secondItem, present())
		if let firstItemUnwrapped = contraintUnwrapped.firstItem as? UIView {
			assertThat(firstItemUnwrapped, equalTo(view))
		} else {
			XCTFail("firstItem is not a UIView")
		}
		if let secondItemUnwrapped = contraintUnwrapped.secondItem as? UIView {
			assertThat(secondItemUnwrapped, equalTo(toView))
		} else {
			XCTFail("secondItem is not a UIView")
		}
	}
	return constraint;
}

	func constraintOnView(_ view: UIView, firstAttribute: NSLayoutAttribute, secondAttribute: NSLayoutAttribute) -> NSLayoutConstraint? {
		for constraint in view.constraints {
			if (constraint.firstAttribute == firstAttribute &&
							constraint.secondAttribute == secondAttribute) {
				return constraint;
			}
		}
		return nil;
	}



	func constraintWithInverseOnView(_ view: UIView, withAttribute attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
		let secondAttribute = layoutHelper.inverseAttribute(attribute)

		for constraint in view.constraints {
			if (constraint.firstAttribute == attribute &&
							constraint.secondAttribute == secondAttribute) {
				return constraint
			}
		}
		return nil;
	}


	func testPinEdgeTopWithToView() {
		let superView = UIView()
		superView.addSubview(view)
		superView.addSubview(toView)

		layoutHelper.pinView(view, toEdge: .top, ofView: toView)

		assertThat(superView.constraints, presentAnd(hasCount(1)))

		self.checkConstraintWithInverse(.top, onView: superView)
	}


	func testPinEdgeTop() {
		toView.addSubview(view)
		layoutHelper.pinView(view, toEdge:.top, ofView:toView)

		assertThat(toView.constraints, hasCount(1))
		self.checkConstraint(.top)
	}


	func testPinEdgeBottom() {
		toView.addSubview(view)
		layoutHelper.pinView(view, toEdge: .bottom, ofView: toView)

		assertThat(toView.constraints, hasCount(1))
		self.checkConstraint(.bottom)
	}


	func testPinEdgeLeft() {
		toView.addSubview(view)
		layoutHelper.pinView(view, toEdge: .left, ofView: toView)

		assertThat(toView.constraints, hasCount(1))
		self.checkConstraint(.left)
	}

	func testPinEdgeRight() {
		toView.addSubview(view)
		layoutHelper.pinView(view, toEdge: .right, ofView: toView)

		assertThat(toView.constraints, hasCount(1))
		self.checkConstraint(.right)
	}

	func testPinToAllEdges() {
		toView.addSubview(view)
		layoutHelper.pinViewToAllEdges(view, ofView: toView)

		assertThat(toView.constraints, hasCount(4))
		self.checkConstraint(.top)
		self.checkConstraint(.bottom)
		self.checkConstraint(.left)
		self.checkConstraint(.right)
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
		layoutHelper.setWidthAndHeightEqualOfView(view)
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
		layoutHelper.pinView(view, toEdge: .topBaseline, ofView: toView)

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
		layoutHelper.pinView(view, toEdge: .bottomBaseline, ofView: toView)

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

		layoutHelper.setMinHeightOfView(view, toValue: 44.0)

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

		layoutHelper.setMinWidthOfView(view, toValue: 144.0)

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

		layoutHelper.setHeightOfView(view, toValue: 44.0)

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

		layoutHelper.setWidthOfView(view, toValue: 144.0)

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

		layoutHelper.verticalCenterView(view)

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

		layoutHelper.horizontalCenterView(view)

		assertThat(toView.constraints, hasCount(1))

		let constraint = constraintAtIndex(0, ofView:toView)
		assertThat(constraint.constant, equalTo(0.0))
		assertThat(constraint.firstAttribute, equalTo(.centerX))
		assertThat(constraint.secondAttribute, equalTo(.centerX))

		assertThatFirstItemOf(constraint, equalToView: view)
		assertThatSecondItemOf(constraint, equalToView: toView)

		assertThat(constraint.relation, equalTo(.equal))
	}


	func testCenterView() {
		toView.addSubview(view)

		layoutHelper.centerView(view)
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

		layoutHelper.horizontalCenterView(view, toView: secondView)

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

		layoutHelper.verticalCenterView(view, toView: secondView)

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

		layoutHelper.centerView(view, toView: secondView)
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


	func testPinViewToGuide() {
		let viewController = UIViewController()
		//presentViewController(viewController)

		viewController.view.addSubview(view)

		layoutHelper.pinView(view, toEdge: .top, withGuide: viewController.topLayoutGuide)

		let constraint = self.constraintOnView(viewController.view, firstAttribute: .top, secondAttribute: .bottom)
		assertThat(constraint, present())

		if let constraintUnwrapped = constraint {
			assertThat(constraintUnwrapped.secondItem, present())
			if let secondItemView = constraintUnwrapped.secondItem as? UILayoutSupport {
				assertThat(secondItemView === viewController.topLayoutGuide)
			} else {
				XCTFail("secondItem is not a UILayoutSupport")
			}

			assertThat(constraintUnwrapped.constant, equalTo(0.0))
			assertThat(constraintUnwrapped.relation, equalTo(.equal))

		}

	}

	func testTwoViewWithSameWidth() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		layoutHelper.setEqualConstantOfView(view, andView: secondView, to:.width)

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

		layoutHelper.setEqualConstantOfView(view, andView: secondView, to:.height)

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

		layoutHelper.setEqualConstantOfView(view, andView: secondView, to:.height, withPriority:100, withMultiplier: 1.0)

		assertThat(toView.constraints, hasCount(1))
		if (toView.constraints.count > 0) {
			let constraint = constraintAtIndex(0, ofView: toView)
			assertThat(constraint.priority, equalTo(100))
		}

	}

	func testViewsHaveSameHeight() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		layoutHelper.setSameHeightOfView(view, andView:secondView)

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

		layoutHelper.setSameHeightOfView(view, andView:secondView, withPriority:101)

		assertThat(toView.constraints, hasCount(1))
		if (toView.constraints.count > 0) {
			let constraint = constraintAtIndex(0, ofView: toView)
			assertThat(constraint.priority, equalTo(101))
		}
	}


	func testViewsHaveSameWidth() {
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		layoutHelper.setSameWidthOfView(view, andView:secondView)

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

		layoutHelper.setSameWidthOfView(view, andView:secondView, withPriority:101)

		assertThat(toView.constraints, hasCount(1))
		if (toView.constraints.count > 0) {
			let constraint = constraintAtIndex(0, ofView: toView)
			assertThat(constraint.priority, equalTo(101))
		}
	}

	func testFindConstraint() {
		toView.addSubview(view)

		layoutHelper.setWidthOfView(view, toValue: 44.0)
		layoutHelper.setHeightOfView(view, toValue: 44.0)

		let constraint = layoutHelper.findConstraintForView(view, attribute:.height)
		assertThat(constraint, present())
		if let constraintUnwrapped = constraint {
			assertThat(constraintUnwrapped.firstAttribute, equalTo(.height))
			assertThat(constraintUnwrapped.secondAttribute, equalTo(.notAnAttribute))
			assertThat(constraintUnwrapped.constant, equalTo(44.0))
		}

	}
}
