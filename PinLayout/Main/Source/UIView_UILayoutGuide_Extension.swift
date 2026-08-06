//
// Created by René Pirringer on 6.8.2026
//

import Foundation
import UIKit

public extension UIView {

	func guide(_ guide: Layout.Guide) -> UILayoutGuide? {
		switch guide {
			case .safeArea:
				return self.safeAreaLayoutGuide
			case .readable:
				return self.readableContentGuide
			case .keyboard:
				if #available(iOS 15, *) {
					return self.keyboardLayoutGuide
				}
				return nil
			case .margins(let cornerAdaptation):
				if #available(iOS 26, *) {
					return self.layoutGuide(for: .margins(cornerAdaptation: cornerAdaptation.convert))
				}
				return nil
			case .content:
				if let scrollView = self as? UIScrollView {
					return scrollView.contentLayoutGuide
				}
				return nil
		}
	}
}

@available(iOS 26, *)
private extension Layout.AdaptivityAxis {

	var convert: UIView.LayoutRegion.AdaptivityAxis {
		switch self {
			case .horizontal: return .horizontal
			case .vertical: return .vertical
		}
	}

}
