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

	func test_pin_leading_with_inset_and_gap_defaults() {
		toView.addSubview(view)
		let insets = createDirectionalInsets()

		// when
		view.layout.pin(.leading, insets: insets,  gap: .margin)

		// then
		assertThat(view, isPinned(.leading, gap: insets.leading))
	}

	func test_pin_leadingReadable_with_inset_and_gap() {
		toView.addSubview(view)
		let insets = createDirectionalInsets()

		// when
		view.layout.pin(.leadingReadable, insets: insets,  gap: 200)

		// then
		assertThat(view, isPinnedToReadableAnchor(.leading, gap: insets.leading))
	}

	func test_pin_leadingSafeArea_with_inset_and_gap() {
		toView.addSubview(view)
		let insets = createDirectionalInsets()

		// when
		view.layout.pin(.leadingSafeArea, insets: insets,  gap: 200)

		// then
		assertThat(view, isPinnedToSafeAreaAnchor(.leading, gap: insets.leading))
	}

	func test_pin_trailing_with_inset_and_gap() {
		toView.addSubview(view)
		let insets = createDirectionalInsets()

		// when
		view.layout.pin(.trailing, insets: insets,  gap: 200)

		// then
		assertThat(view, isPinned(.trailing, gap: insets.trailing))
	}

	func test_pin_trailingReadable_with_inset_and_gap() {
		toView.addSubview(view)
		let insets = createDirectionalInsets()

		// when
		view.layout.pin(.trailingReadable, insets: insets,  gap: 200)

		// then
		assertThat(view, isPinnedToReadableAnchor(.trailing, gap: insets.trailing))
	}

	func test_pin_trailingSafeArea_with_inset_and_gap() {
		toView.addSubview(view)
		let insets = createDirectionalInsets()

		// when
		view.layout.pin(.trailingSafeArea, insets: insets,  gap: 200)

		// then
		assertThat(view, isPinnedToSafeAreaAnchor(.trailing, gap: insets.trailing))
	}


	func test_pin_topSafeArea_with_inset_and_gap() {
		toView.addSubview(view)
		let insets = createDirectionalInsets()

		// when
		view.layout.pin(.topSafeArea, insets: insets,  gap: 200)

		// then
		assertThat(view, isPinnedToSafeAreaAnchor(.top, gap: insets.top))
	}

	func test_pin_bottomSafeArea_with_inset_and_gap() {
		toView.addSubview(view)
		let insets = createDirectionalInsets()

		// when
		view.layout.pin(.bottomSafeArea, insets: insets,  gap: 200)

		// then
		assertThat(view, isPinnedToSafeAreaAnchor(.bottom, gap: insets.bottom))
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
