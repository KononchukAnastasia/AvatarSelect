//
//  CameraPicker.swift
//  AvatarSelect
//
//  Created by Анастасия Конончук on 18.07.2024.
//

import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
    // MARK: - Public Properties

    let completion: (_ image: UIImage, _ fileName: String?) -> Void

    // MARK: - Public Methods

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = ["public.image"]
        return imagePicker
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {}

    func makeCoordinator() -> CameraPickerCoordinator {
        CameraPickerCoordinator(picker: self)
    }
}

// MARK: - Ext. CameraPickerCoordinator

extension CameraPicker {
    final class CameraPickerCoordinator:
        NSObject,
        UIImagePickerControllerDelegate,
        UINavigationControllerDelegate {
        // MARK: - Private Properties

        private let picker: CameraPicker

        private var dateFormatter: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
            return dateFormatter
        }

        // MARK: - Initializers

        init(picker: CameraPicker) {
            self.picker = picker
        }

        // MARK: - Public Methods

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [
                UIImagePickerController.InfoKey: Any
            ]
        ) {
            picker.dismiss(animated: true)

            guard let image = info[.originalImage] as? UIImage else { return }

            let fileName = "IMAGE-\(dateFormatter.string(from: Date()))"
            self.picker.completion(image, fileName)
        }
    }
}
