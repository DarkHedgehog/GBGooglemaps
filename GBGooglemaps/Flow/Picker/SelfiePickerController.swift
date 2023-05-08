//
//  SelfiePickerConreoller.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 08.05.2023.
//

import UIKit

class SelfiePickerController: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private var handler: ((UIImage?) -> Void)?

    init(presentationController: UIViewController) {
        self.pickerController = UIImagePickerController()
        self.presentationController = presentationController

        super.init()

        pickerController.sourceType = .camera
        pickerController.allowsEditing = true
        pickerController.delegate = self
    }

    func present(handler: @escaping (UIImage?) -> Void) {
        self.handler = handler
        presentationController?.present(pickerController, animated: true)
    }
}

extension SelfiePickerController: UINavigationControllerDelegate {

}

extension SelfiePickerController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Если нажали на кнопку Отмена, то UIImagePickerController надо закрыть
        picker.dismiss(animated: true)
        handler?(nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = extractImage(from: info)
        handler?(image)
        picker.dismiss(animated: true)
    }

    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        // Пытаемся извлечь отредактированное изображение
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
            // Пытаемся извлечь оригинальное
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            // Если изображение не получено, возвращаем nil
            return nil
        }
    }
}
