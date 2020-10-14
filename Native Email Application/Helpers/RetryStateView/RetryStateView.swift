//
//  RetryStateView.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

import UIKit
class RetryStateView: UIView {
    var onRetry: (() -> Void)?
    
    @IBAction func retryTapped() {
        self.onRetry?()
    }
}
