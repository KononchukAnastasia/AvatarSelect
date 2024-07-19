//
//  AvatarView.swift
//  AvatarSelect
//
//  Created by Анастасия Конончук on 15.07.2024.
//

import SwiftUI

struct AvatarView: View {
    // MARK: - Property Wrappers
    
    @State private var selectedImage: UIImage?
    @State private var isShowCamera = false
    @State private var isShowPhotoLibrary = false
    @State private var isShowFiles = false
    @State private var isShowActionSheet = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Button(action: { isShowActionSheet = true }) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                }
            }
        }
        .actionSheet(isPresented: $isShowActionSheet) {
            ActionSheet(
                title: Text("Choose Photo"),
                message: Text("Select an option to choose your photo"),
                buttons: [
                    .default(Text("Open Camera")) {
                        openCamera()
                    },
                    .default(Text("Open PhotoLibrary")) {
                        openPhotoLibrary()
                    },
                    .default(Text("Open Files")) {
                        openDocumentPicker()
                    },
                    .destructive(Text("Delete Photo")) {
                        removePhoto()
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            PHPicker { image, _ in
                selectedImage = image
            }
            .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $isShowCamera) {
            CameraPicker { image, _ in
                selectedImage = image
            }
            .ignoresSafeArea()
        }
        .fileImporter(
            isPresented: $isShowFiles,
            allowedContentTypes: [.image]
        ) { result in
            handleFileImport(result: result)
        }
    }
    
    // MARK: - Private Methods
    
    private func openCamera() {
        AccessCameraManager.checkAccessCamera() {
            isShowCamera = true
        }
    }
    
    private func openPhotoLibrary() {
        isShowPhotoLibrary = true
    }
    
    private func openDocumentPicker() {
        isShowFiles = true
    }
    
    private func removePhoto() {
        selectedImage = nil
    }
    
    private func handleFileImport( result: Result<URL, Error> ) {
        switch result {
        case .success(let url):
            if url.startAccessingSecurityScopedResource() {
                defer { url.stopAccessingSecurityScopedResource() }
                
                if let imageData = try? Data(contentsOf: url),
                   let uiImage = UIImage(data: imageData) {
                    selectedImage = uiImage
                }
            }
        case .failure(let error):
            print("Failed to pick file: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview

#Preview {
    AvatarView()
}
