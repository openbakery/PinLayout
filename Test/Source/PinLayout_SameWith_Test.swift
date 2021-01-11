//
// Created by René Pirringer on 11.01.21.
// Copyright (c) 2021 org.openbakery. All rights reserved.
//

import Foundation
import XCTest
import Hamcrest
@testable import PinLayout


class PinLayout_SameWith_Test: PinLayout_Base_Test {

	func test_set_width_and_height_equal() throws {
		toView.addSubview(view)

		// when
		pinLayout.setEqualWidthAndHeight(view:view)

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


	func test_set_width_equal_with_multiplier() throws {
		let otherView = UIView()
		let superview = UIView()
		superview.addSubview(view)
		superview.addSubview(otherView)

		// when
		let multiplier = CGFloat(0.6)
		pinLayout.setEqualWidth(view:view, andView: otherView, multiplier: multiplier)

		// then
		assertThat(superview.constraints, hasCount(1))

		guard let constraint = superview.constraints.first else {
			XCTFail("constraint not present")
			return
		}

		assertThat(constraint.constant, equalTo(0))
		assertThat(constraint.firstAttribute, equalTo(.width))
		assertThat(constraint.secondAttribute, equalTo(.width))


		assertThat(constraint.firstItem, presentAnd(instanceOf(UIView.self, and: equalTo(view))))
		assertThat(constraint.secondItem, presentAnd(instanceOf(UIView.self, and: equalTo(otherView))))

		assertThat(constraint.relation, equalTo(.equal))
		assertThat(Double(constraint.multiplier), closeTo(Double(multiplier), 0.001))
	}


	func test_set_height_equal_with_multiplier() throws {
		let otherView = UIView()
		let superview = UIView()
		superview.addSubview(view)
		superview.addSubview(otherView)

		// when
		let multiplier = CGFloat(0.7)
		pinLayout.setEqualHeight(view:view, andView: otherView, multiplier: multiplier)

		// then
		assertThat(superview.constraints, hasCount(1))

		guard let constraint = superview.constraints.first else {
			XCTFail("constraint not present")
			return
		}

		assertThat(constraint.constant, equalTo(0))
		assertThat(constraint.firstAttribute, equalTo(.height))
		assertThat(constraint.secondAttribute, equalTo(.height))


		assertThat(constraint.firstItem, presentAnd(instanceOf(UIView.self, and: equalTo(view))))
		assertThat(constraint.secondItem, presentAnd(instanceOf(UIView.self, and: equalTo(otherView))))

		assertThat(constraint.relation, equalTo(.equal))
		assertThat(Double(constraint.multiplier), closeTo(Double(multiplier), 0.001))
	}

}
