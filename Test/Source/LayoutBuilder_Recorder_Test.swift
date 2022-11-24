//
// Created by René Pirringer.
// Copyright (c) 2022 org.openbakery. All rights reserved.
//

import Foundation
import UIKit
import XCTest
import Hamcrest
@testable import PinLayout

class LayoutBuilder_Recorder_Test: PinLayout_Base_Test  {

	func test_record_constraints_records_pin_constraints() {
		toView.addSubview(view)

		// when
		let constraints = view.layout.fill().constraints

		// then
		assertThat(constraints, hasCount(4))
	}


	func test_record_setHeight_constraint() {
		toView.addSubview(view)

		// when
		let constraints = view.layout.height(10).constraints

		// then
		assertThat(constraints, hasCount(1))
	}

	func test_record_equal_constraint() {
		// given
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		// when
		let constraints = view.layout.equalHeight(with: view).constraints

		// then
		assertThat(constraints, hasCount(1))
	}

	func test_record_equalWidthAndHeight_constraint() {
		toView.addSubview(view)

		// when
		let constraints = view.layout.equalWidthAndHeight(with: view).constraints

		// then
		assertThat(constraints, hasCount(2))
	}

	func test_record_pinWithGuide_constraint() {
		let viewController = UIViewController()
		viewController.loadViewIfNeeded()
		viewController.view.addSubview(view)

		// when
		let constraints = view.layout.pin(.top).constraints

		// then
		assertThat(constraints, hasCount(1))
	}

	func test_record_pin_with_safeGuide_constraint() {
		let viewController = UIViewController()
		viewController.loadViewIfNeeded()
		viewController.view.addSubview(view)

		// when
		let constraints = view.layout.pin(.leadingSafeArea).constraints

		// then
		assertThat(constraints, hasCount(1))
	}



}
