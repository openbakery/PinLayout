//
// Created by René Pirringer.
// Copyright (c) 2022 org.openbakery. All rights reserved.
//

import Foundation
import UIKit

public class LayoutConstraintsRecorder {
	public var constraints = [NSLayoutConstraint]()

	public init() {
	}

	func append(_ constraint: NSLayoutConstraint) {
		constraints.append(constraint)
	}
}
