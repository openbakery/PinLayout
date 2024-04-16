//
// Created by Rene Pirringer on 08.05.18.
// Copyright (c) 2018 Rene Pirringer. All rights reserved.
//

import Foundation
import XCTest
import Hamcrest
@testable import PinLayout


class PinLayout_Base_Test: XCTestCase {

	var view : UIView!
	var toView : UIView!
	var pinLayout: Layout!

	override func setUp() {
		super.setUp()
		view = UIView()
		toView = UIView()
		pinLayout = Layout()
	}

	override func tearDown() {
		view = nil
		toView = nil
		pinLayout = nil
		super.tearDown()
	}



	@discardableResult func checkConstraint(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
		return self.checkConstraintWithFirstAttribute(attribute, andSecond: attribute)
	}

	@discardableResult func checkConstraintWithFirstAttribute(_ firstAttribute: NSLayoutConstraint.Attribute, andSecond secondAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
		return self.checkConstraintWithFirstAttribute(firstAttribute, andSecond: secondAttribute, onView: toView)
	}

	func checkConstraintWithFirstAttribute(_ firstAttribute: NSLayoutConstraint.Attribute, andSecond secondAttribute: NSLayoutConstraint.Attribute, onView: UIView) -> NSLayoutConstraint? {

		let constraint = self.constraintOnView(onView, firstAttribute: firstAttribute, secondAttribute: secondAttribute)
		assertThat(constraint, present())

		if let constraintUnwrapped = constraint {
			assertThat(constraintUnwrapped.constant, equalTo(0))

			assertThat(constraintUnwrapped.firstAttribute, equalTo(firstAttribute))
			assertThat(constraintUnwrapped.secondAttribute, equalTo(secondAttribute))

			assertThat(constraintUnwrapped.firstItem, present())
			assertThat(constraintUnwrapped.secondItem, present())

			if let firstItemView = constraintUnwrapped.firstItem as? UIView {
				if (firstAttribute == .bottom || firstAttribute == .right || firstAttribute == .trailing) {
					assertThat(firstItemView, equalTo(toView))
				} else {
					assertThat(firstItemView, equalTo(view))
				}
			}

			if let secondItemView = constraintUnwrapped.secondItem as? UIView {
				if (firstAttribute == .bottom || firstAttribute == .right || firstAttribute == .trailing) {
					assertThat(secondItemView, equalTo(view))
				} else {
					assertThat(secondItemView, equalTo(toView))
				}
			}

		}
		return constraint

	}


	@discardableResult func checkConstraintWithInverse(_ attribute: NSLayoutConstraint.Attribute, onView: UIView) -> NSLayoutConstraint? {
		let constraint = self.constraintWithInverseOnView(onView, withAttribute: attribute)
		assertThat(constraint, present())

		if let contraintUnwrapped = constraint {
			assertThat(contraintUnwrapped.constant, equalTo(0))
			assertThat(contraintUnwrapped.firstAttribute, equalTo(attribute))
			assertThat(contraintUnwrapped.secondAttribute, equalTo(pinLayout.inverseAttribute(attribute)))
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

	func constraintOnView(_ view: UIView, firstAttribute: NSLayoutConstraint.Attribute, secondAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
		for constraint in view.constraints {
			if (constraint.firstAttribute == firstAttribute &&
					constraint.secondAttribute == secondAttribute) {
				return constraint;
			}
		}
		return nil;
	}


	func constraintWithInverseOnView(_ view: UIView, withAttribute attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
		let secondAttribute = pinLayout.inverseAttribute(attribute)

		for constraint in view.constraints {
			if (constraint.firstAttribute == attribute &&
					constraint.secondAttribute == secondAttribute) {
				return constraint
			}
		}
		return nil;
	}

	func assertThatFirstItemOf(_ constraint: NSLayoutConstraint, equalToView: UIView, file: StaticString = #filePath, line: UInt = #line) {
		assertThat(constraint.firstItem, present(), file: file, line: line)
		if let firstItemView = constraint.firstItem as? UIView {
			assertThat(firstItemView, equalTo(equalToView), file: file, line: line)
		} else {
			XCTFail("firstItem is not a UIView", file: file, line: line)
		}
	}

	func assertThatSecondItemOf(_ constraint: NSLayoutConstraint, equalToView: UIView, file: StaticString = #filePath, line: UInt = #line) {
		assertThat(constraint.secondItem, present(), file: file, line: line)
		if let secondItemView = constraint.secondItem as? UIView {
			assertThat(secondItemView, equalTo(equalToView), file: file, line: line)
		} else {
			XCTFail("secondItem is not a UIView", file: file, line: line)
		}
	}


	func constraintAtIndex(_ index: Int, ofView:UIView, file: StaticString = #filePath, line: UInt = #line) -> NSLayoutConstraint {
		if (ofView.constraints.count > index) {
			return ofView.constraints[index]
		}
		XCTFail("there is no constraint a index: \(index)", file: file, line: line)
		// return something to make the compiler happy
		return NSLayoutConstraint(item: ofView, attribute:.top, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0.0)
	}
}
