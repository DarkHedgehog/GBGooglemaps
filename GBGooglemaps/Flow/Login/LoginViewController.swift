//
//  LoginViewController.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 18.04.2023.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    var viewModel: LoginViewModel?

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    @IBAction func didTapSignIn(_ sender: Any) {
        guard
            let login = loginField.text,
            let password = passwordField.text else {
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
            let login = loginField.text,
            let password = passwordField.text else {
            return
        }
        if checkIsDataCorrect(login: login, password: password) {
            viewModel?.register(login: login, password: password)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoginBindings()
        loginField.autocorrectionType = .no
    }

    func configureLoginBindings() {
        Observable.combineLatest(
            loginField.rx.text,
            passwordField.rx.text
        )
        .map { login, password in
            return !(login ?? "").isEmpty && (password ?? "").count >= 6
        }
        .bind { [weak self] inputFilled in
            self?.loginButton.isEnabled = inputFilled
            self?.registerButton.isEnabled = inputFilled
        }
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
