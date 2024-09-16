//
// Created by Rene Pirringer on 2019-07-22.
// Copyright (c) 2019 Rene Pirringer. All rights reserved.
//


import Foundation
import Testing
import Hamcrest
import HamcrestSwiftTesting
import PinLayout

struct PinLayout_Defaults_Test {

	let pinLayout = Layout()


	@Test func test_cell_height() {
		#assertThat(pinLayout.value(for:.cellHeight), equalTo(44.0))
	}

	@Test func test_cell_margin() {
		#assertThat(pinLayout.value(for:.cellMargin), equalTo(15.0))
	}

	@Test func test_cell_icon_width() {
		#assertThat(pinLayout.value(for:.cellIconWidth), equalTo(29.0))
	}

	@Test func test_margin() {
		#assertThat(pinLayout.value(for:.margin), equalTo(8.0))
	}

}
