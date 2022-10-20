//
// Created by René Pirringer.
// Copyright (c) 2022 org.openbakery. All rights reserved.
//

import Foundation

public extension NSDirectionalEdgeInsets {

	func value(edge: Layout.Edge) -> CGFloat? {
		switch edge {
		case .leading:
			return self.leading
		case .trailing:
			return self.trailing
		case .top:
			return self.top
		case .bottom:
			return self.bottom
		default:
			return nil
		}
	}
}
