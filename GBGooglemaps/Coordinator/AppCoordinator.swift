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
    var lockController = UIViewController()

    var imagePickerController: SelfiePickerController?

    let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
    let mapStoryboard = UIStoryboard(name: "Main", bundle: nil)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
//        navigationController.pushViewController(UIViewController(), animated: false)
    }

    func present() {
        goToLoginPage() // make root

        if ProfileService.instance.isSignedUp {
            goToMap()
        }
    }

    func goToLoginPage() {
        if !navigationController.children.isEmpty {
            navigationController.popViewController(animated: true)
            return
        }
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

    func gotoTakePicture(for controller: UIViewController, handler: @escaping (UIImage?) -> Void) {
        imagePickerController = SelfiePickerController(presentationController: controller) // Источник изображений: камера
        imagePickerController?.present(handler: handler)
    }

    func lockScreen() {
        lockController.navigationItem.setHidesBackButton(true, animated: false)
        navigationController.pushViewController(lockController, animated: false)
    }

    func unlockScreen() {
        if navigationController.topViewController === lockController {
            navigationController.popViewController(animated: false)
        }
    }
}
