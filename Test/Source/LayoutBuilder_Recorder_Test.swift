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

	var recorder: LayoutConstraintsRecorder!

	override func setUp() {
		super.setUp()
		recorder = LayoutConstraintsRecorder()
	}

	override func tearDown() {
		recorder = nil
		super.tearDown()
	}

	func test_record_constraints_records_pin_constraints() {
		toView.addSubview(view)

		// when
		view.layout(recorder).fill()

		// then
		assertThat(recorder.constraints, hasCount(4))
	}


	func test_record_setHeight_constraint() {
		toView.addSubview(view)

		// when
		view.layout(recorder).height(10)

		// then
		assertThat(recorder.constraints, hasCount(1))
	}

	func test_record_equal_constraint() {
		// given
		let secondView = UIView()
		toView.addSubview(view)
		toView.addSubview(secondView)

		// when
		view.layout(recorder).equalHeight(with: view)

		// then
		assertThat(recorder.constraints, hasCount(1))
	}

	func test_record_equalWidthAndHeight_constraint() {
		toView.addSubview(view)

		// when
		view.layout(recorder).equalWidthAndHeight(with: view)

		// then
		assertThat(recorder.constraints, hasCount(2))
	}

	func test_record_pinWithGuide_constraint() {
		let viewController = UIViewController()
		viewController.loadViewIfNeeded()
		viewController.view.addSubview(view)

		// when
		view.layout(recorder).pin(.top)

		// then
		assertThat(recorder.constraints, hasCount(1))
	}

	func test_record_pin_with_safeGuide_constraint() {
		let viewController = UIViewController()
		viewController.loadViewIfNeeded()
		viewController.view.addSubview(view)

		// when
		view.layout(recorder).pin(.leadingSafeArea)

		// then
		assertThat(recorder.constraints, hasCount(1))
	}



}
