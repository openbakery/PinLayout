//
// Created by René Pirringer
//

import Foundation
import UIKit


@objc(OBPinLayout)
open class PinLayout: NSObject, NSCoding {

	let top = NSLayoutConstraint.Attribute.top

	var recordedConstraints: [NSLayoutConstraint]?

	@objc public override init() {
	}

	@objc open func encode(with aCoder: NSCoder) {
	}

	@objc required public init(coder aDecoder: NSCoder) {
	}


	@objc(OBPinLayoutDefaults) public enum PinLayoutDefaults: Int {
		case cellHeight = 1
		case insets
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

	@objc open func defaultsFor(_ defaults: PinLayoutDefaults) -> Float {
		switch (defaults) {
		case .cellHeight:
			return 44.0
		case .insets:
			return 16.0
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
	open func pin(view: UIView, to edge: PinLayoutHelperEdge, gap: Float) -> NSLayoutConstraint? {
		return self.pin(view: view, to: edge, gap: gap, relatedBy:.equal)
	}


	@objc(pinView:toEdge:gap:relatedBy:)
	@discardableResult
	open func pin(view: UIView, to edge: PinLayoutHelperEdge, gap: Float, relatedBy relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint? {
		if let superview = view.superview {
			if let constraint = self.pinToGuide(for: view, superview: superview, edge: edge, gap: gap) {
				return constraint
			}
			return self.pin(view: view, to: edge, of: superview, gap: gap, multiplier: 1.0, relatedBy: relation)
		}
		return nil
	}


	open func pinToGuide(for view: UIView, superview: UIView, edge: PinLayoutHelperEdge, gap: Float) -> NSLayoutConstraint? {
		var constraint : NSLayoutConstraint?
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
	@discardableResult open func pin(view: UIView, to edge: PinLayoutHelperEdge, of ofView: UIView, gap: Float) -> NSLayoutConstraint? {
		return self.pin(view: view, to: edge, of: ofView, gap: gap, multiplier: 1.0)
	}


	@objc @discardableResult open func pin(view: UIView, to edge: PinLayoutHelperEdge, of ofView: UIView, gap: Float, multiplier: Float, relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
		if let commonSuperView = self.findSuperViewFor(view, ofView) {
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

	@objc @discardableResult open func pin(view: UIView, to edge: PinLayoutHelperEdge, withGuide guide: UILayoutSupport, gap: Float) -> NSLayoutConstraint? {
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
	@discardableResult open func pin(view: UIView, to edge: PinLayoutHelperEdge, of ofView: UIView, withGuide guide: UILayoutSupport, gap: Float) -> NSLayoutConstraint? {

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
	open func pinToAllEdges(view: UIView, gap: Float) {
		if let superview = view.superview {
			self.pinToAllEdges(view: view, of: superview, gap: gap)
		}
	}

	@objc(pingToAllEdges: ofView:gap:)
	open func pinToAllEdges(view: UIView, of ofView: UIView, gap: Float) {
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

	@objc @discardableResult open func setMaxHeightOfView(_ view: UIView, toValue: Float) -> NSLayoutConstraint {
		return self.setMaxHeightOfView(view, toValue: toValue, withPriority: UILayoutPriority.required)
	}

	@objc @discardableResult open func setMaxHeightOfView(_ view: UIView, toValue: Float, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toValue, ofAttribute: .height, toRelation: .lessThanOrEqual, withPriority: withPriority)
	}

	@objc @discardableResult open func setMaxWidthOfView(_ view: UIView, toValue: Float) -> NSLayoutConstraint {
		return self.setMaxWidthOfView(view, toValue: toValue, withPriority: UILayoutPriority.required)
	}

	@objc @discardableResult open func setMaxWidthOfView(_ view: UIView, toValue: Float, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toValue, ofAttribute: .width, toRelation: .lessThanOrEqual, withPriority: withPriority)
	}

	@objc @discardableResult open func setMinHeightOfView(_ view: UIView, toValue: Float) -> NSLayoutConstraint {
		return self.setMinHeightOfView(view, toValue: toValue, withPriority: UILayoutPriority.required)
	}

	@objc @discardableResult open func setMinHeightOfView(_ view: UIView, toValue: Float, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toValue, ofAttribute: .height, toRelation: .greaterThanOrEqual, withPriority: withPriority)
	}

	@objc @discardableResult open func setMinWidthOfView(_ view: UIView, toValue: Float) -> NSLayoutConstraint {
		return self.setMinWidthOfView(view, toValue: toValue, withPriority: UILayoutPriority.required)
	}

	@objc @discardableResult open func setMinWidthOfView(_ view: UIView, toValue: Float, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toValue, ofAttribute: .width, toRelation: .greaterThanOrEqual, withPriority: withPriority)
	}


	@objc(setHeightOfView: toValue:)
	@discardableResult open func setHeight(of view: UIView, toValue: Float) -> NSLayoutConstraint {
		return self.setHeight(of: view, toValue: toValue, withPriority: UILayoutPriority.required)
	}

	@objc(setHeightOfView: toValue:withPriority:)
	@discardableResult open func setHeight(of view: UIView, toValue: Float, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toValue, ofAttribute: .height, withPriority: withPriority)
	}

	@objc(setWidthOfView: toValue:)
	@discardableResult open func setWidth(of view: UIView, toValue: Float) -> NSLayoutConstraint {
		return self.setWidth(of: view, toValue: toValue, withPriority: UILayoutPriority.required)
	}

	@objc(setWidthOfView: toValue:withPriority:)
	@discardableResult open func setWidth(of view: UIView, toValue: Float, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toValue, ofAttribute: .width, withPriority: withPriority)
	}


	@objc @discardableResult open func setConstantOfView(_ view: UIView, toConstant: Float, ofAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toConstant, ofAttribute: ofAttribute, toRelation: .equal, withPriority: UILayoutPriority.required)
	}

	@objc @discardableResult open func setConstantOfView(_ view: UIView, toConstant: Float, ofAttribute: NSLayoutConstraint.Attribute, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toConstant, ofAttribute: ofAttribute, toRelation: .equal, withPriority: withPriority)
	}

	@objc @discardableResult open func setConstantOfView(_ view: UIView, toConstant constant: Float, ofAttribute attribute: NSLayoutConstraint.Attribute, toRelation relation: NSLayoutConstraint.Relation, withPriority priority: UILayoutPriority) -> NSLayoutConstraint {
		view.translatesAutoresizingMaskIntoConstraints = false;
		let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(constant))
		constraint.priority = priority
		view.addConstraint(constraint)
		self.recordedConstraints?.append(constraint)
		return constraint
	}

	@objc open func setEqualConstantOfView(_ view: UIView, andView secondView: UIView, to attribute: PinLayoutConstant, withPriority priority: UILayoutPriority, withMultiplier multiplier: Float) {
		setEqualConstantOfView(view, andView: secondView, withAttribute: toConstantAttribute(attribute), withPriority: priority, withMultiplier: multiplier)
	}


	@objc open func setEqualConstantOfView(_ view: UIView, andView secondView: UIView, to attribute: PinLayoutConstant) {
		setEqualConstantOfView(view, andView: secondView, withAttribute: toConstantAttribute(attribute))
	}


	func setEqualConstantOfView(_ view: UIView, andView secondView: UIView, withAttribute: NSLayoutConstraint.Attribute, withPriority priority: UILayoutPriority, withMultiplier multiplier: Float, withConstant constant: Float = 0) {
		if let commonSuperView = self.findSuperViewFor(view, secondView) {
			let constraint = NSLayoutConstraint(item: view, attribute: withAttribute, relatedBy: .equal, toItem: secondView, attribute: withAttribute, multiplier: CGFloat(multiplier), constant: CGFloat(constant))
			view.translatesAutoresizingMaskIntoConstraints = false
			constraint.priority = priority;
			commonSuperView.addConstraint(constraint)
			self.recordedConstraints?.append(constraint)
		}
	}

	func setEqualConstantOfView(_ view: UIView, andView secondView: UIView, withAttribute: NSLayoutConstraint.Attribute, withConstant constant: Float = 0) {
		setEqualConstantOfView(view, andView: secondView, withAttribute: withAttribute, withPriority: UILayoutPriority(rawValue: 1000), withMultiplier: 1.0, withConstant: constant)
	}

	func setEqualConstantOfView(_ view: UIView, withAttribute: NSLayoutConstraint.Attribute, withConstant constant: Float = 0) {
		if let superview = view.superview {
			self.setEqualConstantOfView(view, andView: superview, withAttribute: withAttribute, withConstant: constant)
		}
	}


	@objc(centerView:toView:)
	open func center(view: UIView, toView secondView: UIView) {
		self.verticalCenter(view: view, toView: secondView)
		self.horizontalCenter(view: view, toView: secondView)
	}

	@objc(centerView:)
	open func center(view: UIView) {
		self.verticalCenter(view: view)
		self.horizontalCenter(view: view)
	}


	@objc(horizontalCenterView:)
	open func horizontalCenter(view: UIView) {
		self.setEqualConstantOfView(view, withAttribute: .centerX)
	}

	@objc open func horizontalCenter(view: UIView, toView secondView: UIView, offset: Float = 0) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .centerX, withConstant: offset)
	}

	@objc open func horizontalCenter(view: UIView, offset: Float) {
		self.setEqualConstantOfView(view, withAttribute: .centerX, withConstant: offset)
	}

	@objc(verticalCenterView:toView:)
	open func verticalCenter(view: UIView, toView secondView: UIView) {
		self.verticalCenter(view: view, toView: secondView, offset: 0)
	}

	@objc(verticalCenterView:toView:offset:)
	open func verticalCenter(view: UIView, toView secondView: UIView, offset: Float = 0) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .centerY, withConstant: offset)
	}

	@objc(verticalCenterView:)
	open func verticalCenter(view: UIView) {
		self.setEqualConstantOfView(view, withAttribute: .centerY)
	}

	@objc(verticalCenterView:offset:) open func verticalCenter(view: UIView, offset: Float) {
		self.setEqualConstantOfView(view, withAttribute: .centerY, withConstant: offset)
	}


	@objc open func setWidthAndHeightEqualOfView(_ view: UIView) {
		let constraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0.0)
		view.addConstraint(constraint)
		self.recordedConstraints?.append(constraint)
	}


	@objc open func setSameHeightOfView(_ view: UIView, andView secondView: UIView) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .height)
	}

	@objc open func setSameHeightOfView(_ view: UIView, andView secondView: UIView, withPriority priority: UILayoutPriority) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .height, withPriority: priority, withMultiplier: 1.0)
	}

	@objc open func setSameHeightOfView(_ view: UIView, andView secondView: UIView, withMultiplier multiplier: Float) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .height, withPriority: UILayoutPriority(rawValue: 1000), withMultiplier: multiplier)
	}

	@objc open func setSameWidthOfView(_ view: UIView, andView secondView: UIView) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .width)
	}

	@objc open func setSameWidthOfView(_ view: UIView, andView secondView: UIView, withMultiplier multiplier: Float) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .width, withPriority: UILayoutPriority(rawValue: 1000), withMultiplier: multiplier)
	}

	@objc open func setSameWidthOfView(_ view: UIView, andView secondView: UIView, withPriority priority: UILayoutPriority) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .width, withPriority: priority, withMultiplier: 1.0)
	}

	@objc(alignView:withView:toEdge:)
	@discardableResult open func align(view first: UIView, with second: UIView, to edge: PinLayoutHelperEdge) -> NSLayoutConstraint? {
		return self.align(view: first, with: second, to: edge, gap: 0)
	}


	@objc(alignView:withView:toEdge:gap:)
	@discardableResult open func align(view first: UIView, with second: UIView, to edge: PinLayoutHelperEdge, gap: Float) -> NSLayoutConstraint? {
		if let superView = self.findSuperViewFor(first, second) {
			let attribute = toLayoutAttribute(edge)
			let constraint = NSLayoutConstraint(item: first, attribute: attribute, relatedBy: .equal, toItem: second, attribute: attribute, multiplier: 1.0, constant: CGFloat(gap))
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
