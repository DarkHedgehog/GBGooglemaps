//
//  Coordinator.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 18.04.2023.
//

import UIKit

protocol Coordinator {
    var parent: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func present()
}
