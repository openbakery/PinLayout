//
// Created by René Pirringer.
// Copyright (c) 2022 org.openbakery. All rights reserved.
//

import Foundation
import UIKit

public extension NSDirectionalEdgeInsets {

	func value(edge: Layout.Edge) -> CGFloat? {
		let value : CGFloat
		switch edge {
		case .leading, .leadingReadable, .leadingSafeArea:
			value = self.leading
		case .trailing, .trailingReadable, .trailingSafeArea:
			value = self.trailing
		case .top, .topSafeArea:
			value = self.top
		case .bottom, .bottomSafeArea:
			value = self.bottom
		default:
			return nil
		}
		if value == 0 {
			return nil
		}
		return value
	}
}
