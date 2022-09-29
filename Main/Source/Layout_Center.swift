//
// Created by René Pirringer on 08.01.21.
// Copyright (c) 2021 org.openbakery. All rights reserved.
//

import Foundation
import UIKit

extension Layout {

	@objc(equalCenterView:)
	@discardableResult
	open func equalCenter(view: UIView) -> [NSLayoutConstraint] {
		if let superview = view.superview {
			return equalCenter(view: view, with: superview)
		}
		return []
	}

	@objc(equalCenterView:toView:)
	@discardableResult
	open func equalCenter(view: UIView, with secondView: UIView) -> [NSLayoutConstraint] {
		var constraints = [NSLayoutConstraint]()
		if let constraint = self.equalCenterY(view: view) {
			constraints.append(constraint)
		}
		if let constraint = self.equalCenterX(view: view) {
			constraints.append(constraint)
		}
		return constraints
	}

	@objc(equalCenterXView:)
	@discardableResult
	open func equalCenterX(view: UIView) -> NSLayoutConstraint? {
		self.setEqualConstant(view: view, attribute: .centerX)
	}

	@objc
	@discardableResult
	open func equalCenterX(view: UIView, toView secondView: UIView, offset: CGFloat = 0) -> NSLayoutConstraint? {
		self.setEqualConstant(view: view, andView: secondView, attribute: .centerX, constant: offset)
	}


	@objc
	@discardableResult
	open func equalCenterX(view: UIView, offset: CGFloat) -> NSLayoutConstraint? {
		self.setEqualConstant(view: view, attribute: .centerX, constant: offset)
	}

	@objc(equalCenterXView:priority:)
	open func equalCenterX(view: UIView, priority: UILayoutPriority) {
		self.setEqualConstant(view: view, andView: view, attribute: .centerX, priority: priority, multiplier: 1.0, constant: 0)
	}

	@objc(equalCenterYView:toView:)
	@discardableResult
	open func equalCenterY(view: UIView, toView secondView: UIView) -> NSLayoutConstraint? {
		self.equalCenterY(view: view, toView: secondView, offset: 0)
	}

	@objc(verticalCenterView:toView:offset:priority:)
	@discardableResult
	open func equalCenterY(view: UIView, toView secondView: UIView, offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
		self.setEqualConstant(view: view, andView: secondView, attribute: .centerY, priority: priority, multiplier: 1.0, constant: offset)
	}

	@objc(equalCenterYView:)
	@discardableResult
	open func equalCenterY(view: UIView) -> NSLayoutConstraint? {
		self.setEqualConstant(view: view, attribute: .centerY)
	}

	@objc(equalCenterYView:priority:)
	@discardableResult
	open func equalCenterY(view: UIView, priority: UILayoutPriority) -> NSLayoutConstraint? {
		self.setEqualConstant(view: view, andView: view, attribute: .centerY, priority: priority, multiplier: 1.0, constant: 0)
	}

	@objc(equalCenterYView:offset:)
	@discardableResult
	open func equalCenterY(view: UIView, offset: CGFloat) -> NSLayoutConstraint? {
		self.setEqualConstant(view: view, attribute: .centerY, constant: offset)
	}

}
