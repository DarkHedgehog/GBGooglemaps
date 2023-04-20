//
//  UserConfirmation.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 16.04.2023.
//

import Foundation
import UIKit

final class UserConfirmation {
    static let instance = UserConfirmation()

    private init() {
    }

    func basicConfirm(presenter: UIViewController, title: String, message: String, handler: @escaping (ConfirmationResult) -> Void ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            handler(ConfirmationResult.cancel)
        })
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            handler(ConfirmationResult.okay)
        })
        presenter.present(alertController, animated: true, completion: nil)
    }

    func basicWarning(presenter: UIViewController, title: String, message: String, handler: @escaping (ConfirmationResult) -> Void ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            handler(ConfirmationResult.okay)
        })
        presenter.present(alertController, animated: true, completion: nil)
    }

    enum ConfirmationResult {
        case okay
        case cancel
    }
}
