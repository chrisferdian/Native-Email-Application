//
//  EmailListCoordinator.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

import UIKit

class EmailListCoordinator: BaseCoordinator {
    var navigationController: UINavigationController?
    
    init(navigationController :UINavigationController?) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewController = EmailListVC()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
