//
//  PHPicker.swift
//  AvatarSelect
//
//  Created by Анастасия Конончук on 15.07.2024.
//

import PhotosUI
import SwiftUI

struct PHPicker: UIViewControllerRepresentable {
    // MARK: - Public Properties

    let completion: (_ image: UIImage, _ fileName: String?) -> Void

    // MARK: - Public Methods

    func makeUIViewController(context: Context) -> UIViewController {
        let photoLibrary = PHPhotoLibrary.shared()

        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) {}

    func makeCoordinator() -> PHPickerCoordinator {
        PHPickerCoordinator(self)
    }
}

// MARK: - Ext. PhotoPickerCoordinator

extension PHPicker {
    final class PHPickerCoordinator: PHPickerViewControllerDelegate {
        // MARK: - Private Properties

        private let picker: PHPicker

        // MARK: - Initializers

        init(_ picker: PHPicker) {
            self.picker = picker
        }

        // MARK: - Public Methods

        func picker(
            _ picker: PHPickerViewController,
            didFinishPicking results: [PHPickerResult]
        ) {
            picker.dismiss(animated: true)

            guard let itemProvider = results.first?.itemProvider,
                  let fileName = itemProvider.suggestedName,
                  itemProvider.canLoadObject(ofClass: UIImage.self)
            else { return }

            loadImage(itemProvider: itemProvider, fileName: fileName)
        }

        // MARK: - Private Methods

        private func loadImage(
            itemProvider: NSItemProvider,
            fileName: String
        ) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let error = error {
                    print("Can't load image \(error.localizedDescription)")
                }

                guard let uiImage = image as? UIImage else { return }

                DispatchQueue.main.async { [weak self] in
                    self?.picker.completion(uiImage, fileName)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    PHPicker { _, _ in }
}
