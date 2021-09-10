//
//  Coordinator.swift
//  ImageSearch
//
//  Created by Roman Arriaga on 9/10/21.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MainViewController(viewModel: ListViewModel(service: NetworkService()))
        navigationController.pushViewController(vc, animated: false)
    }

}
