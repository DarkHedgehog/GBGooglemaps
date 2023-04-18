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

    let storyboard = UIStoryboard(name: "Auth", bundle: nil)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func present() {
        goToLoginPage()
    }

    func goToLoginPage() {
        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            return
        }
        let viewModel = LoginViewModel()
        viewModel.coordinator = self
        loginVC.viewModel = viewModel
        navigationController.pushViewController(loginVC, animated: true)
    }
}
