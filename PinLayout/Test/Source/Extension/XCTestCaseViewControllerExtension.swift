//
// Created by René Pirringer
//

import Foundation
import UIKit
import XCTest

public extension XCTestCase {

	/**
	 Calls all the methods of the UIViewController in the order as it would be, if it is presented in a UIWindow
	 */
	func show(viewController: UIViewController, withTraitCollection: Bool = false) {
		let containerViewController = UIViewController()
		containerViewController.addChild(viewController)

		if withTraitCollection {
			if var traitCollection = UIApplication.shared.delegate?.window??.traitCollection {
				if viewController.traitCollection.verticalSizeClass != .unspecified && viewController.traitCollection.horizontalSizeClass != .unspecified {
					traitCollection = viewController.traitCollection
				}
				containerViewController.setOverrideTraitCollection(traitCollection, forChild: viewController)
			}
		}

		// load the view
		_ = viewController.view

		//if let testNavigationController = viewController as? TestNavigationController {
		//	XCTAssertNotNil(testNavigationController.visibleViewController?.view) // make sure that the view of the visible view controller is loaded
		//}

		viewController.viewWillAppear(false)

		viewController.view.frame = UIScreen.main.bounds
		viewController.viewWillLayoutSubviews()
		viewController.updateViewConstraints()
		viewController.view.layoutSubviews()
		viewController.viewDidLayoutSubviews()
		viewController.viewDidAppear(false)
	}
	


}
