//
// Created by René Pirringer on 08.01.21.
// Copyright (c) 2021 org.openbakery. All rights reserved.
//

import Foundation
import UIKit

extension Layout {

	private func otherView(view: UIView, other: UIView?) -> UIView? {
		view.translatesAutoresizingMaskIntoConstraints = false
		guard let superview = view.superview else {
			return nil
		}
		if other != nil {
			return other
		}
		return superview
	}

	@discardableResult
	@objc(centerXView:)
	open func centerX(view: UIView) -> NSLayoutConstraint? {
		self.centerX(view: view, with: nil, offset: 0)
	}

	@discardableResult
	public func centerX(view: UIView, with other: UIView? = nil, offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
		guard let otherView = self.otherView(view: view, other: other) else {
			return nil
		}
		let constraint = view.centerXAnchor.constraint(equalTo: otherView.centerXAnchor)
		constraint.isActive = true
		constraint.constant = offset
		constraint.priority = priority
		recorder?.append(constraint)
		return constraint
	}

	@discardableResult
	@objc(centerYView:)
	open func centerY(view: UIView) -> NSLayoutConstraint? {
		self.centerY(view: view, with: nil, offset: 0)
	}

	@discardableResult
	public func centerY(view: UIView, with other: UIView? = nil, offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
		guard let otherView = self.otherView(view: view, other: other) else {
			return nil
		}
		let constraint = view.centerYAnchor.constraint(equalTo: otherView.centerYAnchor)
		constraint.isActive = true
		constraint.constant = offset
		constraint.priority = priority
		recorder?.append(constraint)
		return constraint
	}

	@objc(centerView:)
	@discardableResult
	open func center(view: UIView) -> [NSLayoutConstraint] {
		return center(view: view, with: view.superview)
	}

	@discardableResult
	@objc(centerView:toView:)
	open func center(view: UIView, with other: UIView? = nil) -> [NSLayoutConstraint] {
		var result = [NSLayoutConstraint]()

		if let constraint = self.centerX(view: view, with: other) {
			result.append(constraint)
		}

		if let constraint = self.centerY(view: view, with: other) {
			result.append(constraint)
		}

		return result
	}

}
