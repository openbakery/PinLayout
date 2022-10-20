//
// Created by René Pirringer.
// Copyright (c) 2022 org.openbakery. All rights reserved.
//

import Foundation
import UIKit
import XCTest
import Hamcrest
@testable import PinLayout

class LayoutBuilder_Insets_Test: PinLayout_Base_Test {

	func createDirectionalInsets() -> NSDirectionalEdgeInsets {

		return NSDirectionalEdgeInsets(top: 5, leading: 11, bottom: 82, trailing: 21)
	}


	func test_pin_leading_with_inset_and_gap() {
		toView.addSubview(view)
		let insets = createDirectionalInsets()

		// when
		view.layout.pin(.leading, insets: insets,  gap: 200)

		// then
		assertThat(view, isPinned(.leading, gap: insets.leading))
	}

	func test_pin_trailing_with_inset_and_gap() {
		toView.addSubview(view)
		let insets = createDirectionalInsets()

		// when
		view.layout.pin(.trailing, insets: insets,  gap: 200)

		// then
		assertThat(view, isPinned(.trailing, gap: insets.trailing))
	}

	func test_pin_top_inset_and_gap() {
		toView.addSubview(view)
		let insets = createDirectionalInsets()

		// when
		view.layout.pin(.top, insets: insets,  gap: 200)

		// then
		assertThat(view, isPinned(.top, gap: insets.top))
	}

	func test_pin_bottom_inset_and_gap() {
		toView.addSubview(view)
		let insets = createDirectionalInsets()

		// when
		view.layout.pin(.bottom, insets: insets,  gap: 200)

		// then
		assertThat(view, isPinned(.bottom, gap: insets.bottom))
	}
}
