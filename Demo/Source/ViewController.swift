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
	let button = UIButton()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.white

		button.backgroundColor = .blue
		button.setTitle("Press Me", for: .normal)
		button.setTitleColor(UIColor.black, for: .normal)
		button.setTitleColor(UIColor.red, for: .highlighted)
		view.addSubview(button)

		readable()
		readableInsets()
		saveArea()
		saveAreaInsets()
		normal()
		normalInsets()

	}

	func normal() {
		let child = UIView()
		self.view.addSubview(child)
		child.backgroundColor = .clear
		child.layer.borderColor = UIColor.green.cgColor
		child.layer.borderWidth = 1
		layout.pin(view:child, to:.top, gap:20)
		layout.pin(view:child, to:.bottom, gap:20.0)
		layout.pin(view:child, to:.leading, gap:20.0)
		layout.pin(view:child, to:.trailing, gap:20.0)
	}

	func normalInsets() {
		let child = UIView()
		self.view.addSubview(child)
		child.backgroundColor = .clear
		child.layer.borderColor = UIColor.green.cgColor
		child.layer.borderWidth = 1
		let insets = NSDirectionalEdgeInsets(top: 22, leading: 22, bottom: 22, trailing: 22)
		child.layout.pin(.top, .bottom, .leading, .trailing, insets: insets)
	}

	func readable() {
		layout.pin(view:button, to:.top, gap:44.0)
		layout.pin(view:button, to:.bottom, gap:44.0)
		layout.pin(view:button, to:.leadingReadable, gap:44.0)
		layout.pin(view:button, to:.trailingReadable, gap:44.0)
	}

	func readableInsets() {
		let child = UIView()
		self.view.addSubview(child)
		child.backgroundColor = .clear
		child.layer.borderColor = UIColor.blue.cgColor
		child.layer.borderWidth = 1
		let insets = NSDirectionalEdgeInsets(top: 42, leading: 42, bottom: 42, trailing: 42)
		child.layout.pin(.top, .bottom, .leadingReadable, .trailingReadable, insets: insets)
	}

	func saveArea() {
		let child = UIView()
		self.view.addSubview(child)
		child.backgroundColor = .clear
		child.layer.borderColor = UIColor.red.cgColor
		child.layer.borderWidth = 1
		layout.pin(view:child, to:.topSafeArea, gap:44.0)
		layout.pin(view:child, to:.bottomSafeArea, gap:44.0)
		layout.pin(view:child, to:.leadingSafeArea, gap:44.0)
		layout.pin(view:child, to:.trailingSafeArea, gap:44.0)
	}

	func saveAreaInsets() {
		let child = UIView()
		self.view.addSubview(child)
		child.backgroundColor = .clear
		child.layer.borderColor = UIColor.red.cgColor
		child.layer.borderWidth = 1
		let insets = NSDirectionalEdgeInsets(top: 42, leading: 42, bottom: 42, trailing: 42)
		child.layout.pin(.topSafeArea, .bottomSafeArea, .leadingSafeArea, .trailingSafeArea, insets: insets)
	}
}

