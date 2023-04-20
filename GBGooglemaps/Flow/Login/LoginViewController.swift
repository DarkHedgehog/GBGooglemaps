//
//  LoginViewController.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 18.04.2023.
//

import UIKit

class LoginViewController: UIViewController {

    var viewModel: LoginViewModel?

    @IBOutlet weak var loginView: UITextField!
    @IBOutlet weak var passwordView: UITextField!

    @IBAction func didTapSignIn(_ sender: Any) {
        guard
            let login = loginView.text,
            let password = passwordView.text else {
            return
        }
        if checkIsDataCorrect(login: login, password: password) {
            let logged = viewModel?.signIn(login: login, password: password) ?? false
            if !logged {
                UserConfirmation.instance.basicWarning(presenter: self, title: "Invalid data", message: "User not found") { _ in
                }
            }
        }
    }

    @IBAction func didTapRegister(_ sender: Any) {
        guard
            let login = loginView.text,
            let password = passwordView.text else {
            return
        }
        if checkIsDataCorrect(login: login, password: password) {
            viewModel?.register(login: login, password: password)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func checkIsDataCorrect(login: String, password: String) -> Bool {
        guard
            !login.isEmpty,
            !password.isEmpty
        else {
            UserConfirmation.instance.basicWarning(presenter: self, title: "Invalid data", message: "Login and pasword must be set") { _ in
            }
            return false
        }

        return true
    }
}
