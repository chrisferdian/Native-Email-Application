//
//  DetailCoordinator.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 18/10/20.
//

import UIKit

class DetailCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController?
    var element: EmailResponseElement?
    
    init(navigationController :UINavigationController?, content: EmailResponseElement) {
        self.navigationController = navigationController
        self.element = content
    }
    
    override func start() {
        let viewController = DetailsViewController()
        viewController.content = element
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
