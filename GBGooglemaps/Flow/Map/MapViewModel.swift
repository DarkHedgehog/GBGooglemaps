//
//  MapViewModel.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 20.04.2023.
//

import Foundation
import UIKit

final class MapViewModel {
    weak var coordinator: AppCoordinator?

    func logout() {
        coordinator?.goToLoginPage()
    }

    func takePicture(for controller: UIViewController, handler: @escaping (UIImage?) -> Void) {
        coordinator?.gotoTakePicture(for: controller, handler: handler)
    }
}
