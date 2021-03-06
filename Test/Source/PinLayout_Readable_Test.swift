//
// Created by Rene Pirringer on 2019-01-14.
// Copyright (c) 2019 Rene Pirringer. All rights reserved.
//

import Foundation
import XCTest
import Hamcrest
@testable import PinLayout


class PinLayout_Readable_Test : PinLayout_Base_Test {


	@available(iOS 11, *)
	func test_pin_leading_with_readableGuide() {
		toView.addSubview(view)
		pinLayout.pin(view:view, to:.leadingReadable)
		assertThat(view, isPinnedToReadableAnchor(.leading))
		assertThat(view, not(isPinned(.leading)))
	}

	@available(iOS 11, *)
	func test_pin_trailing_with_readableGuide() {
		toView.addSubview(view)
		pinLayout.pin(view:view, to:.trailingReadable)
		assertThat(view, isPinnedToReadableAnchor(.trailing))
		assertThat(view, not(isPinned(.trailing)))
	}


	@available(iOS 11, *)
	func test_pin_leading_with_readableGuide_with_gap() {
		toView.addSubview(view)
		pinLayout.pin(view:view, to:.leadingReadable, gap: 10)
		assertThat(view, isPinnedToReadableAnchor(.leading, gap: 10))
		assertThat(view, not(isPinned(.leading, gap: 10)))
	}

}
