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
	public func centerX(view: UIView, with other: UIView? = nil, offset: CGFloat = 0) -> NSLayoutConstraint? {
		guard let otherView = self.otherView(view: view, other: other) else {
			return nil
		}
		if #available(iOS 11, *) {
			let constraint = view.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: otherView.safeAreaLayoutGuide.centerXAnchor)
			constraint.isActive = true
			constraint.constant = offset
			recorder?.append(constraint)
			return constraint
		}
		return self.equalCenterX(view: view)
	}

	@discardableResult
	@objc(centerYView:)
	open func centerY(view: UIView) -> NSLayoutConstraint? {
		self.centerY(view: view, with: nil, offset: 0)
	}

	@discardableResult
	public func centerY(view: UIView, with other: UIView? = nil, offset: CGFloat = 0) -> NSLayoutConstraint? {
		guard let otherView = self.otherView(view: view, other: other) else {
			return nil
		}
		if #available(iOS 11, *) {
			let constraint = view.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: otherView.safeAreaLayoutGuide.centerYAnchor)
			constraint.isActive = true
			constraint.constant = offset
			recorder?.append(constraint)
			return constraint
		}
		return self.equalCenterY(view: view)
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
