//
// Created by René Pirringer.
// Copyright (c) 2022 org.openbakery. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint.Attribute {
	func constantValue(_ value: CGFloat) -> CGFloat {
		switch self {
		case .trailing, .bottom:
			return -value
		default:
			return value
		}
	}
}
