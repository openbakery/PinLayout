//
//  LayoutBuilder_Guide_Test.swift
//  PinLayout
//
//  Created by René Pirringer on 30.04.26.
//  Copyright © 2026 org.openbakery. All rights reserved.
//

import Foundation
import UIKit
import Testing
import Hamcrest
import HamcrestSwiftTesting
@testable import PinLayout

class LayoutBuilder_Guide_Test: BaseTestCase {
	
	struct LayoutArgument {
		let edge: Layout.Edge
		let attribute: NSLayoutConstraint.Attribute
		
		static let leading = LayoutArgument(edge: .leading, attribute: .leading)
		static let trailing = LayoutArgument(edge: .trailing, attribute: .trailing)
		static let top = LayoutArgument(edge: .top, attribute: .top)
		static let bottom = LayoutArgument(edge: .bottom, attribute: .bottom)
	}
	
	@Test(arguments: [
		LayoutArgument.leading,
		LayoutArgument.trailing,
		LayoutArgument.top,
		LayoutArgument.bottom,
	])
	func pin_to_guide_safeArea(value: LayoutArgument) {
		toView.addSubview(view)

		// when
		view.layout.pin(value.edge, guide: .safeArea)

		// then
		assertThat(view, isPinned(value.attribute, guide: .safeArea))
	}
	
	@Test(arguments: [
		LayoutArgument.leading,
		LayoutArgument.trailing,
		LayoutArgument.top,
		LayoutArgument.bottom,
	])
	func pin_to_guide_readable(value: LayoutArgument) {
		toView.addSubview(view)

		// when
		view.layout.pin(value.edge, guide: .readable)

		// then
		assertThat(view, isPinned(value.attribute, guide: .readable))
	}

	@Test(arguments: [
		LayoutArgument.leading,
		LayoutArgument.trailing,
		LayoutArgument.top,
		LayoutArgument.bottom,
	])
	func pin_to_guide_keyboard(value: LayoutArgument) {
		toView.addSubview(view)

		// when
		view.layout.pin(value.edge, guide: .keyboard)

		// then
		assertThat(view, isPinned(value.attribute, guide: .keyboard))
	}
	
	@Test(arguments: [
		LayoutArgument.leading,
		LayoutArgument.trailing,
		LayoutArgument.top,
		LayoutArgument.bottom,
	])
	func pin_to_contentGuide_for_UIViews_does_not_create_a_constraint(value: LayoutArgument) {
		toView.addSubview(view)

		// when
		view.layout.pin(value.edge, guide: .content)

		// then
		assertThat(view, not(isPinned(value.attribute, guide: .content)))
	}
	
	@Test(arguments: [
		LayoutArgument.leading,
		LayoutArgument.trailing,
		LayoutArgument.top,
		LayoutArgument.bottom,
	])
	func pin_to_contentGuide_for_IIScrollView(value: LayoutArgument) {
		let scrollView = UIScrollView()
		scrollView.addSubview(view)

		// when
		view.layout.pin(value.edge, guide: .content)

		// then
		assertThat(view, isPinned(value.attribute, guide: .content))
	}
}
