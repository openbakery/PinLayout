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

}
