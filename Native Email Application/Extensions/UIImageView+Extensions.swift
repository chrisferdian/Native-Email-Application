//
//  UIImageView+Extensions.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//
import UIKit

extension UIImageView {

    func makeRounded() {

        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
