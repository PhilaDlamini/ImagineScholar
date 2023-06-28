//
//  ImagePicker.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 6/8/23.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else {return}
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) {image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
        //the brigdge between UIKit and SwiftUI
        
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController { //for making the view
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker 
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { //for updating the view
    }
    
    func makeCoordinator() -> Coordinator { //called when swiftui makes an instane of our struct. passed into contect of makeUIViewController
        Coordinator(self)
    }
}
