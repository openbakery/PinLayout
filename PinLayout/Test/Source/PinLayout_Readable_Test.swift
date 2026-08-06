//
// Created by Rene Pirringer on 2019-01-14.
// Copyright (c) 2019 Rene Pirringer. All rights reserved.
//

import Foundation
import Testing
import Hamcrest
import HamcrestSwiftTesting
@testable import PinLayout


class PinLayout_Readable_Test: BaseTestCase {


	@available(iOS 11, *)
	@Test func pin_leading_with_readableGuide() {
		toView.addSubview(view)
		pinLayout.pin(view: view, to: .leadingReadable)
		assertThat(view, isPinnedToReadableAnchor(.leading))
		assertThat(view, not(isPinned(.leading)))
	}

	@available(iOS 11, *)
	@Test func pin_trailing_with_readableGuide() {
		toView.addSubview(view)
		pinLayout.pin(view: view, to: .trailingReadable)
		assertThat(view, isPinnedToReadableAnchor(.trailing))
		assertThat(view, not(isPinned(.trailing)))
	}


	@available(iOS 11, *)
	@Test func pin_leading_with_readableGuide_with_gap() {
		toView.addSubview(view)
		pinLayout.pin(view: view, to: .leadingReadable, gap: 10)
		assertThat(view, isPinnedToReadableAnchor(.leading, gap: 10))
		assertThat(view, not(isPinned(.leading, gap: 10)))
	}

	@Test
	func pin_leading_with_readableGuide_UILayoutGuide() {
		let view = UIView()
		let toView = UIView()
		let pinLayout = Layout()
		toView.addSubview(view)

		// when
		pinLayout.pin(view: view, to: .leading, guide: toView.readableContentGuide)
		pinLayout.pin(view: view, to: .trailing, guide: toView.readableContentGuide)
		pinLayout.pin(view: view, to: .top, guide: toView.readableContentGuide)
		pinLayout.pin(view: view, to: .bottom, guide: toView.readableContentGuide)

		// then
		assertThat(view, isPinnedToReadableAnchor(.leading))
		assertThat(view, isPinnedToReadableAnchor(.trailing))
		assertThat(view, isPinnedToReadableAnchor(.top))
		assertThat(view, isPinnedToReadableAnchor(.bottom))
	}
}
