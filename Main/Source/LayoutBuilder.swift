//
// Created by René Pirringer.
// Copyright (c) 2022 org.openbakery. All rights reserved.
//

import Foundation

public class LayoutBuilder {

	let view: UIView
	let layout: Layout

	init(view: UIView) {
		self.view = view
		self.layout = Layout()
		self.layout.recorder = LayoutConstraintsRecorder()
	}

	public var constraints : [NSLayoutConstraint] {
		self.layout.recorder?.constraints ?? []
	}

	/// stretches the view and fill all available space
	@discardableResult
	public func fill() -> LayoutBuilder {
		_ = self.pin(.leading, .trailing, .top, .bottom)
		return self
	}

	@discardableResult
	public func pin(_ edges: Layout.Edge...) -> LayoutBuilder {
		for edge in edges {
			layout.pin(view: view, to: edge)
		}
		return self
	}

	@discardableResult
	public func pin(_ edges: Layout.Edge..., insets: NSDirectionalEdgeInsets = .zero, gap: CGFloat = 0, priority: UILayoutPriority = .required, relatedBy: NSLayoutConstraint.Relation = .equal) -> LayoutBuilder {
		for edge in edges {
			let gapValue =  insets.value(edge: edge) ?? gap
			if let constraint = layout.pin(view: view, to: edge, gap: gapValue, relatedBy: relatedBy) {
				constraint.priority = priority
			}
		}
		return self
	}

	private func gap(edge: Layout.Edge, insets: NSDirectionalEdgeInsets, default defaultValue: CGFloat) -> CGFloat {
		return insets.value(edge: edge) ?? defaultValue
	}

	@discardableResult
	public func pin(_ edges: Layout.Edge..., insets: NSDirectionalEdgeInsets = .zero, gap: Layout.Defaults, priority: UILayoutPriority = .required) -> LayoutBuilder {
		for edge in edges {
			let gapValue =  insets.value(edge: edge) ?? layout.value(for: gap)
			if let constraint = layout.pin(view: view, to: edge, gap: gapValue) {
				constraint.priority = priority
			}
		}
		return self
	}


	@discardableResult
	public func pin(_ edge: Layout.Edge, to view: UIView,  gap: Layout.Defaults, priority: UILayoutPriority = .required) -> LayoutBuilder {
		let gapValue = layout.value(for: gap)
		return self.pin(edge, to: view, gap: gapValue, priority: priority)
	}

	@discardableResult
	public func pin(_ edge: Layout.Edge, to otherView: UIView, gap: CGFloat = 0, priority: UILayoutPriority = .required) -> LayoutBuilder {
		let result = layout.pin(view: view, to: edge, of: otherView, gap: gap)
		result?.priority = priority
		return self
	}

	@discardableResult
	public func centerX(offset: CGFloat = 0) -> LayoutBuilder {
		layout.centerX(view: view, offset: offset)
		return self
	}


	@discardableResult
	public func centerX(to otherView: UIView) -> LayoutBuilder {
		layout.centerX(view: view, with: otherView)
		return self
	}

	@discardableResult
	public func centerY(offset: CGFloat = 0) -> LayoutBuilder {
		layout.centerY(view: view, offset: offset)
		return self
	}


	@discardableResult
	public func centerY(to otherView: UIView) -> LayoutBuilder {
		layout.centerY(view: view, with: otherView)
		return self
	}


	@discardableResult
	public func center() -> LayoutBuilder {
		self.centerX()
		self.centerY()
		return self
	}

	@discardableResult
	public func center(to otherView: UIView) -> LayoutBuilder {
		self.centerX(to: otherView)
		self.centerY(to: otherView)
		return self
	}


	@discardableResult
	public func minHeight(_ constant: CGFloat) -> LayoutBuilder {
		layout.setMinHeight(of: view, to: constant)
		return self
	}

	@discardableResult
	public func minWidth(_ constant: CGFloat) -> LayoutBuilder {
		layout.setMinWidth(of: view, to: constant)
		return self
	}

	@discardableResult
	public func width(_ constant: CGFloat) -> LayoutBuilder {
		layout.setWidth(of: view, to: constant)
		return self
	}

	@discardableResult
	public func height(_ constant: CGFloat) -> LayoutBuilder {
		layout.setHeight(of: view, to: constant)
		return self
	}

	@discardableResult
	public func equalWidthAndHeight(priority: UILayoutPriority = .required) -> LayoutBuilder {
		layout.setEqualWidthAndHeight(view: view, priority: priority)
		return self
	}


	@discardableResult
	public func equalWidth(with other: UIView, priority: UILayoutPriority = .required, multiplier: CGFloat = 1.0) -> LayoutBuilder {
		layout.setEqualConstant(view: view, andView: other, attribute: .width, priority: priority, multiplier: multiplier)
		return self
	}

	@discardableResult
	public func equalHeight(with other: UIView, priority: UILayoutPriority = .required, multiplier: CGFloat = 1.0) -> LayoutBuilder {
		layout.setEqualConstant(view: view, andView: other, attribute: .height, priority: priority, multiplier: multiplier)
		return self
	}

	@discardableResult
	public func equalWidthAndHeight(with: UIView) -> LayoutBuilder {
		self.equalWidth(with: view)
		self.equalHeight(with: view)
		return self
	}

	public func findConstraint(attribute: Layout.Constant) -> NSLayoutConstraint? {
		layout.findConstraintForView(view, attribute: attribute)
	}

	public func removeAllConstraints() {
		layout.removeAllConstraints(from: view)
	}

	@discardableResult
	public func align(with: UIView, to: Layout.Edge, gap: CGFloat = 0) -> LayoutBuilder {
		layout.align(view: view, with: with, to: to, gap: gap)
		return self
	}
}

