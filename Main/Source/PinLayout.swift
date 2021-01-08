//
// Created by Rene Pirringer on 01.08.16.
//

import Foundation
import UIKit


@objc(OBPinLayout)
open class PinLayout: NSObject, NSCoding {

	let top = NSLayoutConstraint.Attribute.top

	public var recordedConstraints: [NSLayoutConstraint]?

	@objc public override init() {
	}

	@objc open func encode(with aCoder: NSCoder) {
	}

	@objc required public init(coder aDecoder: NSCoder) {
	}


	@objc(OBPinLayoutDefaults) public enum PinLayoutDefaults: Int {
		case cellHeight = 1
		case cellMargin
		case cellIconWidth
		case margin
	}


	@objc(OBPinLayoutConstant) public enum PinLayoutConstant: Int {
		case width = 1
		case height
	}

	@objc(OBPinLayoutEdge) public enum PinLayoutHelperEdge: Int {
		case left = 1
		case right
		case top
		case bottom
		case leading
		case trailing
		case topBaseline
		case bottomBaseline
		case leadingSafeArea
		case trailingSafeArea
		case topSafeArea
		case bottomSafeArea
		case leadingReadable
		case trailingReadable
	}


	func findSuperViewFor(_ first: UIView, _ second: UIView) -> UIView? {
		if (first == second) {
			return first;
		}

		var superView: UIView? = first.superview

		while let firstSuperView = superView {
			if (firstSuperView == second) {
				return firstSuperView;
			}
			superView = firstSuperView.superview;
		}

		if let secondSuperview = second.superview {
			return self.findSuperViewFor(first, secondSuperview)
		}
		return nil
	}

	@objc(valueFor:)
	open func value(for defaults: PinLayoutDefaults) -> CGFloat {
		switch (defaults) {
		case .cellHeight:
			return 44.0
		case .cellMargin:
			return 15.0
		case .cellIconWidth:
			return 29.0
		case .margin:
			return 8
		}
	}

	@objc(pinView: toEdge:relatedBy:) @discardableResult open func pin(view: UIView, to edge: PinLayoutHelperEdge, relatedBy relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint? {
		if let superview = view.superview {
			return self.pin(view: view, to: edge, of: superview, gap: 0, multiplier: 1.0, relatedBy: relation)
		}
		return nil
	}


	@objc(pinView:toEdge:)
	@discardableResult
	open func pin(view: UIView, to edge: PinLayoutHelperEdge) -> NSLayoutConstraint? {
		return self.pin(view: view, to: edge, gap: 0)
	}


	@discardableResult
	@objc(pinView:toEdge:gap:)
	open func pin(view: UIView, to edge: PinLayoutHelperEdge, gap: CGFloat) -> NSLayoutConstraint? {
		return self.pin(view: view, to: edge, gap: gap, relatedBy:.equal)
	}


	@objc(pinView:toEdge:gap:relatedBy:)
	@discardableResult
	open func pin(view: UIView, to edge: PinLayoutHelperEdge, gap: CGFloat, relatedBy relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint? {
		if let superview = view.superview {
			return self.pin(view: view, to: edge, of: superview, gap: gap, multiplier: 1.0, relatedBy: relation)
		}
		return nil
	}


	open func pinToGuide(for view: UIView, superview: UIView, edge: PinLayoutHelperEdge, gap: CGFloat) -> NSLayoutConstraint? {
		var constraint : NSLayoutConstraint?
		view.translatesAutoresizingMaskIntoConstraints = false
		if #available(iOS 11, *) {
			switch edge {
			case .leadingSafeArea:
				constraint = superview.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor)
			case .trailingSafeArea:
				constraint = superview.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			case .topSafeArea:
				constraint = superview.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor)
			case .bottomSafeArea:
				constraint = superview.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			default:
				break
			}
		}

		if #available(iOS 9, *) {
			switch edge {
			case .leadingReadable:
				constraint = superview.readableContentGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor)
			case .trailingReadable:
				constraint = superview.readableContentGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			default:
				break
			}
		}
		
		if let constraint = constraint {
			constraint.constant = CGFloat(-gap)
			constraint.isActive = true
			self.recordedConstraints?.append(constraint)
			return constraint
		}
		return nil
	}

	@objc(pinView:toEdge:ofView:)
	@discardableResult open func pin(view: UIView, to edge: PinLayoutHelperEdge, of ofView: UIView) -> NSLayoutConstraint? {
		return self.pin(view: view, to: edge, of: ofView, gap: 0.0)
	}


	@objc(pinView:toEdge:ofView:gap:)
	@discardableResult open func pin(view: UIView, to edge: PinLayoutHelperEdge, of ofView: UIView, gap: CGFloat) -> NSLayoutConstraint? {
		return self.pin(view: view, to: edge, of: ofView, gap: gap, multiplier: 1.0)
	}


	@objc @discardableResult open func pin(view: UIView, to edge: PinLayoutHelperEdge, of ofView: UIView, gap: CGFloat, multiplier: CGFloat, relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
		if let commonSuperView = self.findSuperViewFor(view, ofView) {
			
			if let constraint = self.pinToGuide(for: view, superview: commonSuperView, edge: edge, gap: gap) {
				return constraint
			}
			
			view.translatesAutoresizingMaskIntoConstraints = false

			var firstView = view
			var secondView = ofView

			var attribute = toLayoutAttribute(edge)
			var toAttribute = attribute
			if (commonSuperView != ofView) {
				toAttribute = inverseAttribute(attribute);
			}

			if (attribute == .firstBaseline) {
				toAttribute = .top;
			} else if (attribute == .lastBaseline) {
				attribute = .bottom;
				toAttribute = .lastBaseline;
				secondView = view
				firstView = ofView
			} else if (attribute == toAttribute && (attribute == .bottom || attribute == .right || attribute == .trailing)) {
				secondView = view
				firstView = ofView
			}

			let constraint = NSLayoutConstraint(item: firstView, attribute: attribute, relatedBy: relation, toItem: secondView, attribute: toAttribute, multiplier: CGFloat(multiplier), constant: CGFloat(gap))
			commonSuperView.addConstraint(constraint)
			recordedConstraints?.append(constraint)
			return constraint
		}
		return nil;
	}

	@objc(pinView:toEdge:withGuide:)
	@discardableResult open func pin(view: UIView, to edge: PinLayoutHelperEdge, withGuide guide: UILayoutSupport) -> NSLayoutConstraint? {
		return self.pin(view: view, to: edge, withGuide: guide, gap: 0)
	}

	@objc @discardableResult open func pin(view: UIView, to edge: PinLayoutHelperEdge, withGuide guide: UILayoutSupport, gap: CGFloat) -> NSLayoutConstraint? {
		if let superview = view.superview {
			return self.pin(view: view, to: edge, of: superview, withGuide: guide, gap: gap)
		}
		return nil
	}

	@objc(pinView:toEdge:ofView:withGuide:)
	@discardableResult open func pin(view: UIView, to edge: PinLayoutHelperEdge, of ofView: UIView, withGuide guide: UILayoutSupport) -> NSLayoutConstraint? {
		return self.pin(view: view, to: edge, of: ofView, withGuide: guide, gap: 0.0)
	}

	@objc(pinView:toEdge:ofView:withGuide:gap:)
	@discardableResult open func pin(view: UIView, to edge: PinLayoutHelperEdge, of ofView: UIView, withGuide guide: UILayoutSupport, gap: CGFloat) -> NSLayoutConstraint? {

		if let commonSuperView = self.findSuperViewFor(view, ofView) {
			if let constraint = self.pinToGuide(for: view, superview: commonSuperView, edge: edge, gap: gap) {
				constraint.constant = CGFloat(gap)
				return constraint
			}


			view.translatesAutoresizingMaskIntoConstraints = false
			let attribute = toLayoutAttribute(edge)
			let toAttribute = self.inverseAttribute(attribute)
			let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: guide, attribute: toAttribute, multiplier: 1.0, constant: CGFloat(gap))
			commonSuperView.addConstraint(constraint)
			self.recordedConstraints?.append(constraint)
			return constraint
		}
		return nil
	}


	@objc(pinToAllEdges:)
	open func pinToAllEdges(view: UIView) {
		self.pinToAllEdges(view: view, gap: 0)
	}

	@objc(pinToAllEdges: ofView:)
	open func pinToAllEdges(view: UIView, of ofView: UIView) {
		self.pinToAllEdges(view: view, of: ofView, gap: 0)
	}

	@objc(pingToAllEdges: gap:)
	open func pinToAllEdges(view: UIView, gap: CGFloat) {
		if let superview = view.superview {
			self.pinToAllEdges(view: view, of: superview, gap: gap)
		}
	}

	@objc(pingToAllEdges: ofView:gap:)
	open func pinToAllEdges(view: UIView, of ofView: UIView, gap: CGFloat) {
		self.pin(view: view, to: .top, of: ofView, gap: gap)
		self.pin(view: view, to: .bottom, of: ofView, gap: gap)
		self.pin(view: view, to: .leading, of: ofView, gap: gap)
		self.pin(view: view, to: .trailing, of: ofView, gap: gap)
	}


	func toLayoutAttribute(_ attribute: PinLayoutHelperEdge) -> NSLayoutConstraint.Attribute {
		switch (attribute) {
		case .left:
			return NSLayoutConstraint.Attribute.left
		case .right:
			return NSLayoutConstraint.Attribute.right
		case .top, .topSafeArea:
			return NSLayoutConstraint.Attribute.top
		case .bottom, .bottomSafeArea:
			return NSLayoutConstraint.Attribute.bottom
		case .leading, .leadingSafeArea, .leadingReadable:
			return NSLayoutConstraint.Attribute.leading
		case .trailing, .trailingSafeArea, .trailingReadable:
			return NSLayoutConstraint.Attribute.trailing
		case .topBaseline:
			return NSLayoutConstraint.Attribute.firstBaseline
		case .bottomBaseline:
			return NSLayoutConstraint.Attribute.lastBaseline
		}
	}

	open func inverseAttribute(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint.Attribute {
		switch (attribute) {
		case .top:
			return .bottom
		case .bottom:
			return .top
		case .right:
			return .left
		case .left:
			return .right
		case .leading:
			return .trailing
		case .trailing:
			return .leading
		default:
			return attribute
		}
	}

	func toConstantAttribute(_ attribute: PinLayoutConstant) -> NSLayoutConstraint.Attribute {
		switch (attribute) {
		case .height:
			return NSLayoutConstraint.Attribute.height
		case .width:
			return NSLayoutConstraint.Attribute.width
		}
	}

	@objc(setMaxHeightOfView:to:)
	@discardableResult open func setMaxHeight(of view: UIView, to value: CGFloat) -> NSLayoutConstraint {
		return self.setMaxHeight(of: view, to: value, priority: UILayoutPriority.required)
	}

	@objc(setMaxHeightOfView:to:priority:)
	@discardableResult open func setMaxHeight(of view: UIView, to value: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstant(view: view, constant: value, attribute: .height, relation: .lessThanOrEqual, priority: priority)
	}

	@objc(setMaxWidthOfView:to:)
	@discardableResult open func setMaxWidth(of view: UIView, to value: CGFloat) -> NSLayoutConstraint {
		return self.setMaxWidth(of: view, to: value, priority: UILayoutPriority.required)
	}

	@objc(setMaxWidthOfView:to:priority:)
	@discardableResult open func setMaxWidth(of view: UIView, to value: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstant(view: view, constant: value, attribute: .width, relation: .lessThanOrEqual, priority: priority)
	}

	@objc(setMinHeightOfView:to:)
	@discardableResult open func setMinHeight(of view: UIView, to value: CGFloat) -> NSLayoutConstraint {
		return self.setMinHeight(of: view, to: value, priority: UILayoutPriority.required)
	}

	@objc(setMinHeightOfView:to:priority:)
	@discardableResult open func setMinHeight(of view: UIView, to value: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstant(view: view, constant: value, attribute: .height, relation: .greaterThanOrEqual, priority: priority)
	}

	@objc(setMinWidthOfView:to:)
	@discardableResult open func setMinWidth(of view: UIView, to value: CGFloat) -> NSLayoutConstraint {
		return self.setMinWidth(of: view, to: value, priority: UILayoutPriority.required)
	}

	@objc(setMinWidthOfView:to:priority:)
	@discardableResult
	open func setMinWidth(of view: UIView, to value: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstant(view: view, constant: value, attribute: .width, relation: .greaterThanOrEqual, priority: priority)
	}


	@objc(setHeightOfView:to:)
	@discardableResult open func setHeight(of view: UIView, to value: CGFloat) -> NSLayoutConstraint {
		return self.setHeight(of: view, to: value, priority: UILayoutPriority.required)
	}

	@objc(setHeightOfView:to:priority:)
	@discardableResult open func setHeight(of view: UIView, to value: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstant(view: view, constant: value, attribute: .height, priority: priority)
	}

	@objc(setWidthOfView:to:)
	@discardableResult open func setWidth(of view: UIView, to value: CGFloat) -> NSLayoutConstraint {
		return self.setWidth(of: view, to: value, priority: UILayoutPriority.required)
	}

	@objc(setWidthOfView:to:priority:)
	@discardableResult open func setWidth(of view: UIView, to value: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstant(view: view, constant: value, attribute: .width, priority: priority)
	}


	@objc
	@discardableResult open func setConstant(view: UIView, constant: CGFloat, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint {
		return self.setConstant(view: view, constant: constant, attribute: attribute, relation: .equal, priority: UILayoutPriority.required)
	}

	@objc @discardableResult open func setConstant(view: UIView, constant: CGFloat, attribute: NSLayoutConstraint.Attribute, priority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstant(view: view, constant: constant, attribute: attribute, relation: .equal, priority: priority)
	}

	@objc @discardableResult open func setConstant(view: UIView,
																								 constant: CGFloat,
																								 attribute: NSLayoutConstraint.Attribute,
																								 relation: NSLayoutConstraint.Relation,
																								 priority: UILayoutPriority) -> NSLayoutConstraint {
		view.translatesAutoresizingMaskIntoConstraints = false;
		let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant)
		constraint.priority = priority
		view.addConstraint(constraint)
		self.recordedConstraints?.append(constraint)
		return constraint
	}

	@objc
	open func setEqualConstant(view: UIView, andView secondView: UIView, attribute: PinLayoutConstant, priority: UILayoutPriority, multiplier: CGFloat) {
		setEqualConstant(view: view, andView: secondView, attribute: toConstantAttribute(attribute), priority: priority, multiplier: multiplier)
	}


	@objc open func setEqualConstant(view: UIView, andView secondView: UIView, attribute: PinLayoutConstant) {
		setEqualConstant(view: view, andView: secondView, attribute: toConstantAttribute(attribute))
	}

	
	@discardableResult
	func setEqualConstant(view: UIView, andView secondView: UIView, attribute: NSLayoutConstraint.Attribute, priority: UILayoutPriority, multiplier: CGFloat, constant: CGFloat = 0) -> NSLayoutConstraint? {
		if let commonSuperView = self.findSuperViewFor(view, secondView) {
			let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: secondView, attribute: attribute, multiplier: multiplier, constant: constant)
			view.translatesAutoresizingMaskIntoConstraints = false
			constraint.priority = priority;
			commonSuperView.addConstraint(constraint)
			self.recordedConstraints?.append(constraint)
			return constraint
		}
		return nil
	}

	@discardableResult
	func setEqualConstant(view: UIView, andView secondView: UIView, attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0) -> NSLayoutConstraint? {
		setEqualConstant(view: view, andView: secondView, attribute: attribute, priority: UILayoutPriority(rawValue: 1000), multiplier: 1.0, constant: constant)
	}

	@discardableResult
	func setEqualConstant(view: UIView, attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0) -> NSLayoutConstraint? {
		if let superview = view.superview {
			return self.setEqualConstant(view: view, andView: superview, attribute: attribute, constant: constant)
		}
		return nil
	}



	@objc open func setEqualWidthAndHeight(view: UIView) {
		let constraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0.0)
		view.addConstraint(constraint)
		self.recordedConstraints?.append(constraint)
	}


	@objc open func setEqualHeight(view: UIView, andView secondView: UIView) {
		self.setEqualConstant(view: view, andView: secondView, attribute: .height)
	}

	@objc open func setEqualHeight(view: UIView, andView secondView: UIView, priority: UILayoutPriority) {
		self.setEqualConstant(view: view, andView: secondView, attribute: .height, priority: priority, multiplier: 1.0)
	}

	@objc open func setEqualHeight(view: UIView, andView secondView: UIView, multiplier: CGFloat) {
		self.setEqualConstant(view: view, andView: secondView, attribute: .height, priority: UILayoutPriority(rawValue: 1000), multiplier: multiplier)
	}

	@objc open func setEqualWidth(view: UIView, andView secondView: UIView) {
		self.setEqualConstant(view: view, andView: secondView, attribute: .width)
	}

	@objc open func setEqualWidth(view: UIView, andView secondView: UIView, multiplier: CGFloat) {
		self.setEqualConstant(view: view, andView: secondView, attribute: .width, priority: UILayoutPriority(rawValue: 1000), multiplier: multiplier)
	}

	@objc open func setEqualWidth(view: UIView, andView secondView: UIView, priority: UILayoutPriority) {
		self.setEqualConstant(view: view, andView: secondView, attribute: .width, priority: priority, multiplier: 1.0)
	}

	@objc(alignView:withView:toEdge:)
	@discardableResult open func align(view first: UIView, with second: UIView, to edge: PinLayoutHelperEdge) -> NSLayoutConstraint? {
		return self.align(view: first, with: second, to: edge, gap: 0)
	}


	@objc(alignView:withView:toEdge:gap:)
	@discardableResult open func align(view first: UIView, with second: UIView, to edge: PinLayoutHelperEdge, gap: CGFloat) -> NSLayoutConstraint? {
		if let superView = self.findSuperViewFor(first, second) {
			let attribute = toLayoutAttribute(edge)
			let constraint = NSLayoutConstraint(item: first, attribute: attribute, relatedBy: .equal, toItem: second, attribute: attribute, multiplier: 1.0, constant: gap)
			superView.addConstraint(constraint)
			self.recordedConstraints?.append(constraint)
			return constraint
		}
		return nil
	}


	@objc open func findConstraintForView(_ view: UIView, attribute: PinLayoutConstant) -> NSLayoutConstraint? {
		for constraint in view.constraints {
			if constraint.firstAttribute == toConstantAttribute(attribute) &&
				 constraint.secondAttribute == .notAnAttribute {
				return constraint
			}
		}
		return nil
	}


	open func removeAllConstraints(from fromView: UIView?) {
		var view = fromView
		while let currentView = view {
			currentView.removeConstraints(currentView.constraints.filter {
				return $0.firstItem as? UIView == fromView || $0.secondItem as? UIView == fromView
			})
			view = view?.superview
		}
	}

	/**
	 * Starts recording all the contraints that are added to the views.
	 * Calling this method always starts a new recording, so all previous recorded constraints are lost.
	 */
	open func startRecord() {
		self.recordedConstraints = []
	}

	/**
	 * Finishes the recording.
	 * @returns the recorded constraints
	 */
	open func finishRecord() -> [NSLayoutConstraint] {
		if let result = self.recordedConstraints {
			self.recordedConstraints = nil
			return result
		}
		return []
	}
}
