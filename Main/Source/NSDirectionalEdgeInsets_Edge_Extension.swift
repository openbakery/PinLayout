//
// Created by René Pirringer.
// Copyright (c) 2022 org.openbakery. All rights reserved.
//

import Foundation

public extension NSDirectionalEdgeInsets {

	func value(edge: Layout.Edge) -> CGFloat? {
		let value : CGFloat
		switch edge {
		case .leading:
			value = self.leading
		case .trailing:
			value = self.trailing
		case .top:
			value = self.top
		case .bottom:
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
