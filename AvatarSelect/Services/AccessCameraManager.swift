//
//  AccessCameraManager.swift
//  AvatarSelect
//
//  Created by Анастасия Конончук on 16.07.2024.
//

import UIKit
import AVFoundation

final class AccessCameraManager {
    // MARK: - Public Methods
    
    static func checkAccessCamera(completion: (() -> Void)?) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied, .restricted:
            showAlert()
        case .authorized:
            completion?()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        completion?()
                    }
                }
            }
        default:
            break
        }
    }
    
    // MARK: - Private Methods
    
    private static func showAlert(
        title: String = "Need access to the camera",
        message: String = "Allow access to the camera in the settings app"
    ) {
        guard let rootViewController = getRootViewController() else { return }
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        alert.addAction(
            UIAlertAction(
                title: "Open Settings",
                style: .default,
                handler: { _ in openSettings() }
            )
        )
        
        rootViewController.present(alert, animated: true)
    }
    
    private static func getRootViewController() -> UIViewController? {
        UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }?
            .rootViewController
    }
    
    private static func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
