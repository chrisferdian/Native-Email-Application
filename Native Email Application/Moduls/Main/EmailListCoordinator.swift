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
        let viewModel = EmailListVM()
        
        viewController.viewModel = viewModel
        viewModel.didTapToDetail = { element in
            self.navigateToDetail(element: element)
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToDetail(element: EmailResponseElement) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, content: element)
        self.store(coordinator: detailCoordinator)

        detailCoordinator.start()
        
        // detect when free it
        detailCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: detailCoordinator)
        }
    }
}
