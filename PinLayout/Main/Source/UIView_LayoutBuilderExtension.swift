//
// Created by René Pirringer.
// Copyright (c) 2022 org.openbakery. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
	var layout: LayoutBuilder {
		return LayoutBuilder(view: self)
	}

	
	func guide(_ guide: Layout.Guide) -> UILayoutGuide? {
		switch guide {
		case .safeArea:
			return self.safeAreaLayoutGuide
		case .readable:
			return self.readableContentGuide
		case .keyboard:
			if #available(iOS 15, *) {
				return self.keyboardLayoutGuide
			} else {
				return nil
			}
		case .content:
			if let scrollView = self as? UIScrollView {
				return scrollView.contentLayoutGuide
			}
			return nil
		}
	}
}

