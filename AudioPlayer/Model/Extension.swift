//
//  Extension.swift
//  AudioPlayer
//
//  Created by Sonun Usubalieva on 10/11/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {addSubview($0) }
    }
}
