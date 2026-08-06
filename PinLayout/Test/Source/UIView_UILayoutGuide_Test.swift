//
// Created by René Pirringer on 6.8.2026
//


import Foundation
import UIKit
import Testing
import Hamcrest
import HamcrestSwiftTesting
@testable import PinLayout

@MainActor
class UIView_UILayoutGuide_Test {


	@Test
	func `safearea`() {
		let view = UIView()

		// when
		let guide = view.guide(.safeArea)

		// when
		assertThat(guide, presentAnd(equalTo(view.safeAreaLayoutGuide)))
	}

	@Test
	func `readable`() {
		let view = UIView()

		// when
		let guide = view.guide(.readable)

		// when
		assertThat(guide, presentAnd(equalTo(view.readableContentGuide)))
	}

	@available(iOS 15, *)
	@Test
	func `keyboard`() {
		let view = UIView()

		// when
		let guide = view.guide(.keyboard)

		// when
		assertThat(guide, presentAnd(equalTo(view.keyboardLayoutGuide)))
	}


	@available(iOS 26, *)
	@Test
	func `margins horizontal`() {
		let view = UIView()

		// when
		let guide = view.guide(.margins(.horizontal))

		// when
		let contentGuide = view.layoutGuide(for: .margins(cornerAdaptation: .horizontal))
		assertThat(guide, presentAnd(equalTo(contentGuide)))
	}

	@available(iOS 26, *)
	@Test
	func `margins vertical`() {
		let view = UIView()

		// when
		let guide = view.guide(.margins(.vertical))

		// when
		let contentGuide = view.layoutGuide(for: .margins(cornerAdaptation: .vertical))
		assertThat(guide, presentAnd(equalTo(contentGuide)))
	}
}
