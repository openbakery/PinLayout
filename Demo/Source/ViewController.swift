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

	public enum Guide: CustomStringConvertible {
		case none, readable, safeArea

		public var description: String {
			switch self {
			case .none:
				return "None"
			case .readable:
				return "Readable"
			case .safeArea:
				return "SafeArea"
			}
		}

		public var next: Guide {
			switch self {
			case .none:
				return .readable
			case .readable:
				return .safeArea
			case .safeArea:
				return .none
			}
		}

		public var edges: [Layout.Edge] {
			switch self {
			case .none:
				return [.leading, .trailing, .top, .bottom]
			case .readable:
				return [.leadingReadable, .trailingReadable, .top, .bottom]
			case .safeArea:
				return [.leadingSafeArea, .trailingSafeArea, .topSafeArea, .bottomSafeArea]
			}
		}
	}

	var guide: Guide = .none

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.green

		button.setTitleColor(UIColor.black, for: .normal)
		button.setTitleColor(UIColor.red, for: .highlighted)
		button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
		createViews()
	}

	func createViews() {
		for view in self.view.subviews {
			view.removeFromSuperview()
		}
		createView(color: .white)
		let insets = NSDirectionalEdgeInsets(top: 44, leading: 44, bottom: 44, trailing: 44)
		createView(color: UIColor(white: 0.0, alpha: 0.2), insets: insets)

		button.setTitle(self.guide.description, for: .normal)
		view.addSubview(button)
		button.layout.center()

	}

	@objc
	func buttonPressed() {
		self.guide = self.guide.next
		createViews()
	}

	func createView(color: UIColor, insets: NSDirectionalEdgeInsets = .zero) {
		let view = UIView()
		view.backgroundColor = color
		self.view.addSubview(view)
		for edge in self.guide.edges {
			view.layout.pin(edge, insets: insets)
		}
	}

}

