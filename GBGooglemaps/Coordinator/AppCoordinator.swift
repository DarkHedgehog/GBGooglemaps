//
//  AppCoordinator.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 18.04.2023.
//

import UIKit

final class AppCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
    let mapStoryboard = UIStoryboard(name: "Main", bundle: nil)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func present() {
        if ProfileService.instance.isSignedUp {
            goToMap()
        } else {
            goToLoginPage()
        }
    }

    func goToLoginPage() {
        guard let loginVC = authStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            return
        }
        let viewModel = LoginViewModel()
        viewModel.coordinator = self
        loginVC.viewModel = viewModel
        navigationController.pushViewController(loginVC, animated: true)
    }

    func goToMap() {
        guard let mapVC = mapStoryboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else {
            return
        }
        let viewModel = MapViewModel()
        viewModel.coordinator = self
        mapVC.viewModel = viewModel
        navigationController.pushViewController(mapVC, animated: true)
    }
}
