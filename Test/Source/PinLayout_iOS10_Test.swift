//
// Created by Rene Pirringer on 08.05.18.
// Copyright (c) 2018 Rene Pirringer. All rights reserved.
//


import Foundation
import XCTest
import Hamcrest
@testable import PinLayout

protocol TopLayoutGuide {
	var topLayoutGuide: UILayoutSupport { get }
}

class MyViewController: UIViewController, TopLayoutGuide {
	
}


class PinLayout_For_isOS10: PinLayout {

	override func pinToGuide(for view: UIView, superview: UIView, edge: PinLayoutHelperEdge, gap: CGFloat) -> NSLayoutConstraint? {
		return nil
	}
}


class PinLayout_iOS10_Test :PinLayout_Base_Test {


	override func setUp() {
		super.setUp()
		pinLayout = PinLayout_For_isOS10()
	}




	func test_iOS10_safeGuide_Top_pins_using_topLayoutGuide() {

		let viewController = MyViewController()
		show(viewController:viewController)

		viewController.view.addSubview(view)

		pinLayout.pin(view: view, to: .topSafeArea, withGuide: (viewController as TopLayoutGuide).topLayoutGuide)

		let constraint = self.constraintOnView(viewController.view, firstAttribute: .top, secondAttribute: .bottom)
		assertThat(constraint, present())

		if let constraintUnwrapped = constraint {
			assertThat(constraintUnwrapped.secondItem, present())
			if let secondItemView = constraintUnwrapped.secondItem as? UILayoutSupport {
				assertThat(secondItemView === (viewController as TopLayoutGuide).topLayoutGuide)
			} else {
				XCTFail("secondItem is not a UILayoutSupport")
			}
			assertThat(constraintUnwrapped.constant, equalTo(0.0))
			assertThat(constraintUnwrapped.relation, equalTo(.equal))
		}

	}
	
	
	func testPinViewToGuide() {
		let viewController = MyViewController()
		show(viewController:viewController)

		viewController.view.addSubview(view)

		pinLayout.pin(view:view, to: .top, withGuide: (viewController as TopLayoutGuide).topLayoutGuide)

		let constraint = self.constraintOnView(viewController.view, firstAttribute: .top, secondAttribute: .bottom)
		assertThat(constraint, present())

		if let constraintUnwrapped = constraint {
			assertThat(constraintUnwrapped.secondItem, present())
			if let secondItemView = constraintUnwrapped.secondItem as? UILayoutSupport {
				assertThat(secondItemView === (viewController as TopLayoutGuide).topLayoutGuide)
			} else {
				XCTFail("secondItem is not a UILayoutSupport")
			}

			assertThat(constraintUnwrapped.constant, equalTo(0.0))
			assertThat(constraintUnwrapped.relation, equalTo(.equal))

		}

	}


}

