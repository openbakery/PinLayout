//
// Created by René Pirringer.
// Copyright (c) 2022 org.openbakery. All rights reserved.
//

import Foundation

public extension UIView {
	var layout: LayoutBuilder {
		return LayoutBuilder(view: self)
	}

	func layout(_ recorder: LayoutConstraintsRecorder) -> LayoutBuilder {
		return LayoutBuilder(view: self, recorder: recorder)
	}

}

