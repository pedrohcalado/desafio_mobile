//
//  UIButton+TestHelpers.swift
//  ByCodersAppTests
//
//  Created by Pedro Henrique Calado on 02/12/22.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
