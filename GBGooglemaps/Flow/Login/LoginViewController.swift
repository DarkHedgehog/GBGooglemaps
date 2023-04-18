//
//  LoginViewController.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 18.04.2023.
//

import UIKit

class LoginViewController: UIViewController {

    var viewModel: LoginViewModel?

    enum Constants {
        static let login = "admin"
        static let password = "123456"
    }

    @IBOutlet weak var loginView: UITextField!
    @IBOutlet weak var passwordView: UITextField!

    @IBAction func login(_ sender: Any) {
        guard
            let login = loginView.text,
            let password = passwordView.text,
            login == Constants.login && password == Constants.password
        else {
            return
        }

        print("Логин")
    }

    @IBAction func recovery(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
