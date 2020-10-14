//
//  UITableView+Extensions.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }

    func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
    
    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection: self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    internal func setStateView(with state: ListProcessingState, _ completion: (() -> Void)? = nil) {
        tableFooterView = UIView()
        switch state {
        case .success:
            self.backgroundView = nil
            return
        case .empty:
                guard let stateView = Bundle.main.loadNibNamed("EmptyStateView", owner: self, options: nil)?.first as? EmptyStateView else { return }
                self.backgroundView = stateView
        case .retry:
            guard let stateView = Bundle.main.loadNibNamed("RetryStateView", owner: self, options: nil)?.first as? RetryStateView else { return }
            self.backgroundView = stateView
            stateView.onRetry = completion
            return
        default:
            guard let stateView = Bundle.main.loadNibNamed("LoadingStateView", owner: self, options: nil)?.first as? LoadingStateView else { return }
            self.backgroundView = stateView
        }
    }
}

enum ListProcessingState {
    case success
    case empty
    case retry
    case loading
}
