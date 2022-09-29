//
// Created by René Pirringer.
// Copyright (c) 2022 org.openbakery. All rights reserved.
//

import Foundation

public class LayoutBuilder {

	let view: UIView
	let layout: Layout

	init(view: UIView, recorder: LayoutConstraintsRecorder? = nil) {
		self.view = view
		self.layout = Layout()
		self.layout.recorder = recorder
	}

	/// stretches the view and fill all available space
	public func fill() {
		self.pin(.leading, .trailing, .top, .bottom)
	}

	public func pin(_ edges: Layout.Edge...) {
		for edge in edges {
			layout.pin(view: view, to: edge)
		}
	}

	@discardableResult
	public func pin(_ edges: Layout.Edge..., gap: CGFloat = 0, priority: UILayoutPriority = .required, relatedBy: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
		var result = [NSLayoutConstraint]()
		for edge in edges {
			if let constraint = layout.pin(view: view, to: edge, gap: gap, relatedBy: relatedBy) {
				constraint.priority = priority
				result.append(constraint)
			}
		}
		return result
	}

	@discardableResult
	public func pin(_ edges: Layout.Edge..., gap: Layout.Defaults, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
		var result = [NSLayoutConstraint]()
		for edge in edges {
			let gapValue = value(edge: edge, for: gap)
			if let constraint = layout.pin(view: view, to: edge, gap: gapValue) {
				constraint.priority = priority
				result.append(constraint)
			}
		}
		return result
	}

	public func value(edge: Layout.Edge, for gap: Layout.Defaults) -> CGFloat {
		let gapValue = layout.value(for: gap)
		switch edge {
		case .trailingReadable,
				 .trailing,
				 .trailingSafeArea:
			return -gapValue
		default:
			return gapValue
		}
	}



	@discardableResult
	public func pin(_ edge: Layout.Edge, to view: UIView,  gap: Layout.Defaults, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
		let gapValue = layout.value(for: gap)
		return self.pin(edge, to: view, gap: gapValue, priority: priority)
	}

	@discardableResult
	public func pin(_ edge: Layout.Edge, to otherView: UIView, gap: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
		let result = layout.pin(view: view, to: edge, of: otherView, gap: gap)
		result?.priority = priority
		return result
	}

	@discardableResult
	public func centerX(offset: CGFloat = 0) -> NSLayoutConstraint? {
		layout.centerX(view: view, offset: offset)
	}


	@discardableResult
	public func centerX(to otherView: UIView) -> NSLayoutConstraint? {
		layout.centerX(view: view, with: otherView)
	}

	@discardableResult
	public func centerY(offset: CGFloat = 0) -> NSLayoutConstraint? {
		layout.centerY(view: view, offset: offset)
	}


	@discardableResult
	public func centerY(to otherView: UIView) -> NSLayoutConstraint? {
		layout.centerY(view: view, with: otherView)
	}


	@discardableResult
	public func center() -> [NSLayoutConstraint] {
		var result = [NSLayoutConstraint]()
		if let constraint = self.centerX() {
			result.append(constraint)
		}
		if let constraint = self.centerY() {
			result.append(constraint)
		}
		return result
	}

	@discardableResult
	public func center(to otherView: UIView) -> [NSLayoutConstraint] {
		var result = [NSLayoutConstraint]()
		if let constraint = self.centerX(to: otherView) {
			result.append(constraint)
		}
		if let constraint = self.centerY(to: otherView) {
			result.append(constraint)
		}
		return result
	}


	public func minHeight(_ constant: CGFloat) {
		layout.setMinHeight(of: view, to: constant)
	}

	public func minWidth(_ constant: CGFloat) {
		layout.setMinWidth(of: view, to: constant)
	}

	public func width(_ constant: CGFloat) {
		layout.setWidth(of: view, to: constant)
	}

	public func height(_ constant: CGFloat) {
		layout.setHeight(of: view, to: constant)
	}
/*
	public func setEqualWidthAndHeight(priority: UILayoutPriority = .required) {
		layout.setEqualWidthAndHeight(view: view)?.priority = priority
	}
*/

	@discardableResult
	public func equalWidth(with other: UIView, priority: UILayoutPriority = .required, multiplier: CGFloat = 1.0) -> NSLayoutConstraint? {
		layout.setEqualConstant(view: view, andView: other, attribute: .width, priority: priority, multiplier: multiplier)
	}

	@discardableResult
	public func equalHeight(with other: UIView, priority: UILayoutPriority = .required, multiplier: CGFloat = 1.0) -> NSLayoutConstraint? {
		layout.setEqualConstant(view: view, andView: other, attribute: .height, priority: priority, multiplier: multiplier)
	}

	@discardableResult
	public func equalWidthAndHeight(with: UIView) -> [NSLayoutConstraint] {
		var result = [NSLayoutConstraint]()
		if let constraint = self.equalWidth(with: view) {
			result.append(constraint)
		}
		if let constraint = self.equalHeight(with: view) {
			result.append(constraint)
		}
		return result
	}

	public func findConstraint(attribute: Layout.Constant) -> NSLayoutConstraint? {
		layout.findConstraintForView(view, attribute: attribute)
	}

	public func removeAllConstraints() {
		layout.removeAllConstraints(from: view)
	}

	public func align(with: UIView, to: Layout.Edge, gap: CGFloat = 0) {
		layout.align(view: view, with: with, to: to, gap: gap)
	}
}

