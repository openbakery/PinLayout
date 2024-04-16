//
// Created by Rene Pirringer on 2019-08-06.
// Copyright (c) 2019 Rene Pirringer. All rights reserved.
//

import Foundation
import XCTest
import Hamcrest
@testable import PinLayout

class PinLayout_AutoResizing_Test : PinLayout_Base_Test {



	func test_disables_translatesAutoresizingMaskIntoConstraints() {
		let superView = UIView()
		superView.addSubview(view)
		pinLayout.pin(view:view, to: .top)
		assertThat(view.translatesAutoresizingMaskIntoConstraints, equalTo(false))
	}

	func test_not_disables_translatesAutoresizingMaskIntoConstraints_on_superview() {
		let superView = UIView()
		superView.addSubview(view)
		pinLayout.pin(view:view, to: .top)
		assertThat(superView.translatesAutoresizingMaskIntoConstraints, equalTo(true))
	}


	func test_for_tableCells_contentView_translatesAutoresizingMaskIntoConstraints_is_not_set_to_false() {
		let cell = UITableViewCell()
		cell.addSubview(view)
		pinLayout.pin(view:cell, to: .top, of: toView)
		assertThat(cell.translatesAutoresizingMaskIntoConstraints, equalTo(true))
	}

}
