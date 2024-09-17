//
// Created by Rene Pirringer on 2019-08-06.
// Copyright (c) 2019 Rene Pirringer. All rights reserved.
//

import Foundation
import Testing
import Hamcrest
import HamcrestSwiftTesting
import PinLayout
import UIKit

@MainActor
struct PinLayout_AutoResizing_SwiftTest {
	let view = UIView()
	let toView = UIView()
	let pinLayout = Layout()


	@Test func disables_translatesAutoresizingMaskIntoConstraints() {
		let superView = UIView()
		superView.addSubview(view)
		pinLayout.pin(view:view, to: .top)

		#assertThat(view.translatesAutoresizingMaskIntoConstraints, equalTo(false))
	}

	@Test func not_disables_translatesAutoresizingMaskIntoConstraints_on_superview() {
		let superView = UIView()
		superView.addSubview(view)
		pinLayout.pin(view:view, to: .top)
		#assertThat(superView.translatesAutoresizingMaskIntoConstraints, equalTo(true))
	}

	@Test func for_tableCells_contentView_translatesAutoresizingMaskIntoConstraints_is_not_set_to_false() {
		let cell = UITableViewCell()
		cell.addSubview(view)
		pinLayout.pin(view:cell, to: .top, of: toView)
		#assertThat(cell.translatesAutoresizingMaskIntoConstraints, equalTo(true))
	}

}
