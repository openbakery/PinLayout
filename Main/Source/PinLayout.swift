//
// Created by Rene Pirringer on 01.08.16.
//

import Foundation
import UIKit



@objc(OBPinLayout)
open class PinLayout: NSObject, NSCoding {

	let top = NSLayoutAttribute.top

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

	@objc(OBPinLayoutEdge) public enum PinLayoutEdge: Int {
		case left = 1
		case right
		case top
		case bottom
		case leading
		case trailing
		case topBaseline
		case bottomBaseline
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

	@objc @discardableResult open func pinView(_ view: UIView, toEdge edge: PinLayoutEdge) -> NSLayoutConstraint? {
		return self.pinView(view, toEdge:edge, gap: 0)
	}

	@objc @discardableResult open func pinView(_ view: UIView, toEdge edge: PinLayoutEdge, gap: Float) -> NSLayoutConstraint? {
		if let superview = view.superview {
			return self.pinView(view, toEdge: edge, ofView: superview, gap: gap)
		}
		return nil
	}

	@objc @discardableResult open func pinView(_ view: UIView, toEdge edge: PinLayoutEdge, ofView: UIView) -> NSLayoutConstraint? {
		return self.pinView(view, toEdge: edge, ofView: ofView, gap: 0.0)
	}


	@objc @discardableResult open func pinView(_ view: UIView, toEdge edge: PinLayoutEdge, ofView: UIView, gap: Float) -> NSLayoutConstraint? {
		return self.pinView(view, toEdge: edge, ofView: ofView, gap: gap, multiplier: 1.0)
	}


	@objc @discardableResult open func pinView(_ view: UIView, toEdge edge: PinLayoutEdge, ofView: UIView, gap: Float, multiplier: Float) -> NSLayoutConstraint? {
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
			} else if (attribute == toAttribute && (attribute == .bottom || attribute == .right || attribute == .trailing )) {
				secondView = view
				firstView = ofView
			}

			let constraint = NSLayoutConstraint(item: firstView, attribute: attribute, relatedBy: .equal, toItem: secondView, attribute: toAttribute, multiplier: CGFloat(multiplier), constant: CGFloat(gap))
			commonSuperView.addConstraint(constraint)
			return constraint
		}
		return nil;
	}

	@objc @discardableResult open func pinView(_ view: UIView, toEdge edge: PinLayoutEdge, withGuide guide: UILayoutSupport) -> NSLayoutConstraint? {
		return self.pinView(view, toEdge: edge, withGuide: guide, gap: 0)
	}

	@objc @discardableResult open func pinView(_ view: UIView, toEdge edge: PinLayoutEdge, withGuide guide: UILayoutSupport, gap: Float) -> NSLayoutConstraint? {
		if let superview = view.superview {
			return self.pinView(view, toEdge: edge, ofView: superview, withGuide: guide, gap: gap)
		}
		return nil
	}

	@objc @discardableResult open func pinView(_ view: UIView, toEdge edge: PinLayoutEdge, ofView: UIView, withGuide guide: UILayoutSupport) -> NSLayoutConstraint? {
		return self.pinView(view, toEdge: edge, ofView: ofView, withGuide: guide, gap: 0.0)
	}

	@objc @discardableResult open func pinView(_ view: UIView, toEdge edge: PinLayoutEdge, ofView: UIView, withGuide guide: UILayoutSupport, gap: Float) -> NSLayoutConstraint? {
		if let commonSuperView = self.findSuperViewFor(view, ofView) {
			view.translatesAutoresizingMaskIntoConstraints = false
			let attribute = toLayoutAttribute(edge)
			let toAttribute = self.inverseAttribute(attribute)
			let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: guide, attribute: toAttribute, multiplier: 1.0, constant: CGFloat(gap))
			commonSuperView.addConstraint(constraint)
			return constraint
		}
		return nil
	}


	@objc open func pinViewToAllEdges(_ view: UIView) {
		self.pinViewToAllEdges(view, gap: 0)
	}

	@objc open func pinViewToAllEdges(_ view: UIView, ofView: UIView) {
		self.pinViewToAllEdges(view, ofView: ofView, gap: 0)
	}

	@objc open func pinViewToAllEdges(_ view: UIView, gap: Float) {
		if let superview = view.superview {
			self.pinViewToAllEdges(view, ofView: superview, gap: gap)
		}
	}


	@objc open func pinViewToAllEdges(_ view: UIView, ofView: UIView, gap: Float) {
		self.pinView(view, toEdge: .top, ofView: ofView, gap: gap)
		self.pinView(view, toEdge: .bottom, ofView: ofView, gap: gap)
		self.pinView(view, toEdge: .left, ofView: ofView, gap: gap)
		self.pinView(view, toEdge: .right, ofView: ofView, gap: gap)
	}


	func toLayoutAttribute(_ attribute: PinLayoutEdge) -> NSLayoutAttribute {
		switch (attribute) {
		case .left:
			return NSLayoutAttribute.left
		case .right:
			return NSLayoutAttribute.right
		case .top:
			return NSLayoutAttribute.top
		case .bottom:
			return NSLayoutAttribute.bottom
		case .leading:
			return NSLayoutAttribute.leading
		case .trailing:
			return NSLayoutAttribute.trailing
		case .topBaseline:
			return NSLayoutAttribute.firstBaseline
		case .bottomBaseline:
			return NSLayoutAttribute.lastBaseline
		}
	}

	open func inverseAttribute(_ attribute: NSLayoutAttribute) -> NSLayoutAttribute {
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

	func toConstantAttribute(_ attribute: PinLayoutConstant) -> NSLayoutAttribute {
		switch (attribute) {
		case .height:
			return NSLayoutAttribute.height
		case .width:
			return NSLayoutAttribute.width
		}
	}

	@objc @discardableResult open func setMaxHeightOfView(_ view: UIView, toValue: Float) -> NSLayoutConstraint {
		return self.setMaxHeightOfView(view, toValue: toValue, withPriority: UILayoutPriorityRequired)
	}

	@objc @discardableResult open func setMaxHeightOfView(_ view: UIView, toValue: Float, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toValue, ofAttribute: .height, toRelation: .lessThanOrEqual, withPriority: withPriority)
	}

	@objc @discardableResult open func setMaxWidthOfView(_ view: UIView, toValue: Float) -> NSLayoutConstraint {
		return self.setMaxWidthOfView(view, toValue: toValue, withPriority: UILayoutPriorityRequired)
	}

	@objc @discardableResult open func setMaxWidthOfView(_ view: UIView, toValue: Float, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toValue, ofAttribute: .width, toRelation: .lessThanOrEqual, withPriority: withPriority)
	}

	@objc @discardableResult open func setMinHeightOfView(_ view: UIView, toValue: Float) -> NSLayoutConstraint {
		return self.setMinHeightOfView(view, toValue: toValue, withPriority: UILayoutPriorityRequired)
	}

	@objc @discardableResult open func setMinHeightOfView(_ view: UIView, toValue: Float, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toValue, ofAttribute: .height, toRelation: .greaterThanOrEqual, withPriority: withPriority)
	}

	@objc @discardableResult open func setMinWidthOfView(_ view: UIView, toValue: Float) -> NSLayoutConstraint {
		return self.setMinWidthOfView(view, toValue: toValue, withPriority: UILayoutPriorityRequired)
	}

	@objc @discardableResult open func setMinWidthOfView(_ view: UIView, toValue: Float, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toValue, ofAttribute: .width, toRelation: .greaterThanOrEqual, withPriority: withPriority)
	}


	@objc @discardableResult open func setHeightOfView(_ view: UIView, toValue: Float) -> NSLayoutConstraint {
		return self.setHeightOfView(view, toValue: toValue, withPriority: UILayoutPriorityRequired)
	}

	@objc @discardableResult open func setHeightOfView(_ view: UIView, toValue: Float, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toValue, ofAttribute: .height, withPriority: withPriority)
	}

	@objc @discardableResult open func setWidthOfView(_ view: UIView, toValue: Float) -> NSLayoutConstraint {
		return self.setWidthOfView(view, toValue: toValue, withPriority: UILayoutPriorityRequired)
	}

	@objc @discardableResult open func setWidthOfView(_ view: UIView, toValue: Float, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toValue, ofAttribute: .width, withPriority: withPriority)
	}


	@objc @discardableResult open func setConstantOfView(_ view: UIView, toConstant: Float, ofAttribute: NSLayoutAttribute) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toConstant, ofAttribute: ofAttribute, toRelation: .equal, withPriority: UILayoutPriorityRequired)
	}

	@objc @discardableResult open func setConstantOfView(_ view: UIView, toConstant: Float, ofAttribute: NSLayoutAttribute, withPriority: UILayoutPriority) -> NSLayoutConstraint {
		return self.setConstantOfView(view, toConstant: toConstant, ofAttribute: ofAttribute, toRelation: .equal, withPriority: withPriority)
	}

	@objc @discardableResult open func setConstantOfView(_ view: UIView, toConstant constant: Float, ofAttribute attribute: NSLayoutAttribute, toRelation relation: NSLayoutRelation, withPriority priority: UILayoutPriority) -> NSLayoutConstraint {
		view.translatesAutoresizingMaskIntoConstraints = false;
		let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(constant))
		constraint.priority = priority;
		view.addConstraint(constraint)
		return constraint
	}

	@objc open func setEqualConstantOfView(_ view: UIView, andView secondView: UIView, to attribute: PinLayoutConstant, withPriority priority: UILayoutPriority, withMultiplier multiplier: Float) {
		setEqualConstantOfView(view, andView:secondView, withAttribute: toConstantAttribute(attribute), withPriority:priority, withMultiplier: multiplier)
	}


	@objc open func setEqualConstantOfView(_ view: UIView, andView secondView: UIView, to attribute: PinLayoutConstant) {
		setEqualConstantOfView(view, andView:secondView, withAttribute: toConstantAttribute(attribute))
	}


	func setEqualConstantOfView(_ view: UIView, andView secondView: UIView, withAttribute: NSLayoutAttribute, withPriority priority: UILayoutPriority, withMultiplier multiplier: Float) {
		if let commonSuperView = self.findSuperViewFor(view, secondView) {
			let constraint = NSLayoutConstraint(item: view, attribute: withAttribute, relatedBy: .equal, toItem: secondView, attribute: withAttribute, multiplier: CGFloat(multiplier), constant: 0.0)
			view.translatesAutoresizingMaskIntoConstraints = false
			constraint.priority = priority;
			commonSuperView.addConstraint(constraint)
		}
	}

	func setEqualConstantOfView(_ view: UIView, andView secondView: UIView, withAttribute: NSLayoutAttribute) {
		setEqualConstantOfView(view, andView:secondView, withAttribute: withAttribute, withPriority: 1000, withMultiplier: 1.0)
	}

	func setEqualConstantOfView(_ view: UIView, withAttribute: NSLayoutAttribute) {
		if let superview = view.superview {
			self.setEqualConstantOfView(view, andView: superview, withAttribute: withAttribute)
		}
	}


	@objc open func centerView(_ view: UIView, toView secondView: UIView) {
		self.verticalCenterView(view, toView:secondView)
		self.horizontalCenterView(view, toView:secondView)
	}

	@objc open func centerView(_ view: UIView) {
		self.verticalCenterView(view)
		self.horizontalCenterView(view)
	}


	@objc open func horizontalCenterView(_ view: UIView) {
		self.setEqualConstantOfView(view, withAttribute: .centerX)
	}

	@objc open func horizontalCenterView(_ view: UIView, toView secondView: UIView) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .centerX)
	}


	@objc open func verticalCenterView(_ view: UIView, toView secondView: UIView) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .centerY)
	}

	@objc open func verticalCenterView(_ view: UIView) {
		self.setEqualConstantOfView(view, withAttribute: .centerY)
	}


	@objc open func setWidthAndHeightEqualOfView(_ view: UIView) {
		let constraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0.0)
		view.addConstraint(constraint)
	}


	@objc open func setSameHeightOfView(_ view: UIView, andView secondView: UIView) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .height)
	}

	@objc open func setSameHeightOfView(_ view: UIView, andView secondView: UIView, withPriority priority: UILayoutPriority) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .height, withPriority:priority, withMultiplier: 1.0)
	}

	@objc open func setSameHeightOfView(_ view: UIView, andView secondView: UIView, withMultiplier multiplier: Float) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .height, withPriority:1000, withMultiplier:multiplier)
	}

	@objc open func setSameWidthOfView(_ view: UIView, andView secondView: UIView) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .width)
	}

	@objc open func setSameWidthOfView(_ view: UIView, andView secondView: UIView, withMultiplier multiplier: Float) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .width, withPriority:1000, withMultiplier:multiplier)
	}

	@objc open func setSameWidthOfView(_ view: UIView, andView secondView: UIView, withPriority priority: UILayoutPriority) {
		self.setEqualConstantOfView(view, andView: secondView, withAttribute: .width, withPriority:priority, withMultiplier: 1.0)
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
}
