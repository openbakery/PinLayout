//
//  ViewController.swift
//  PinLayoutDemo
//
//  Created by Rene Pirringer on 02.01.17.
//  Copyright © 2017 org.openbakery. All rights reserved.
//

import UIKit
import PinLayout

class ViewController: UIViewController {

	let layout = Layout()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.white


		let button = UIButton()
		button.setTitle("Press Me", for: .normal)
		button.setTitleColor(UIColor.black, for: .normal)
		button.setTitleColor(UIColor.red, for: .highlighted)
		view.addSubview(button)


		layout.pin(view:button, to:.topSafeArea, gap:44.0)
		layout.equalCenterX(view: button)

	}


}

