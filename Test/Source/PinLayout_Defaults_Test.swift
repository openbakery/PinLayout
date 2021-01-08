//
// Created by Rene Pirringer on 2019-07-22.
// Copyright (c) 2019 Rene Pirringer. All rights reserved.
//


import Foundation
import XCTest
import Hamcrest
@testable import PinLayout

class PinLayout_Defaults_Test : PinLayout_Base_Test {


	func test_cell_height() {
		assertThat(pinLayout.value(for:.cellHeight), equalTo(44.0))
	}

	func test_cell_margin() {
		assertThat(pinLayout.value(for:.cellMargin), equalTo(15.0))
	}

	func test_cell_icon_width() {
		assertThat(pinLayout.value(for:.cellIconWidth), equalTo(29.0))
	}

	func test_margin() {
		assertThat(pinLayout.value(for:.margin), equalTo(8.0))
	}

}
