//
//  AppCoordinator.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

protocol Coordinator : class {
    var childCoordinators : [Coordinator] { get set }
    func start()
}
extension Coordinator {

    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
