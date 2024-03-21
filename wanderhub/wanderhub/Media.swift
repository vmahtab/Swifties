//
//  Media.swift
//  wanderhub
//
//  Created by Neha Tiwari on 3/21/24.
//

import Foundation
import SwiftUI
import UIKit
import AVKit

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    @Binding var sourceType: UIImagePickerController.SourceType?
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType ?? .camera
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image"]
        
        return picker
    }
    
    func updateUIViewController(_ picker: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let controller: ImagePicker
        init(_ controller: ImagePicker) {
            self.controller = controller
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            controller.dismiss()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage ?? info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                controller.image = image.resizeImage(targetSize: CGSize(width: 150, height: 181))
            }
            controller.dismiss()
            controller.dismiss()
        }
    }
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage? {
        // Figure out orientation, and use it to form a rectangle
        let ratio = (targetSize.width > targetSize.height) ?
        targetSize.height / size.height :
        targetSize.width / size.width
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Do the actual resizing to the calculated rectangle
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
