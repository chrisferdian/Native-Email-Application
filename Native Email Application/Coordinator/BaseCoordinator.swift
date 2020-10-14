//
//  BaseCoordinator.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

import Foundation

class BaseCoordinator : Coordinator {
    var childCoordinators : [Coordinator] = []
    var isCompleted: (() -> ())?

    func start() {
        fatalError("Children should implement `start`.")
    }
}
