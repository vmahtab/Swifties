//
//  PostView.swift
//  swiftUIChatter
//
//  Created by Neha Tiwari on 2/5/24.
//

import SwiftUI

struct CameraView: View {

    
    private let username = "tiwarin"
    @State private var message = "Some short sample text."
    @State private var image: UIImage? = nil
    @State private var videoUrl: URL? = nil
    
    @State private var isPresenting = false
    @State private var sourceType: UIImagePickerController.SourceType? = nil
    
    var body: some View {
        VStack {
            Text(username)
                .padding(.top, 30.0)
            TextEditor(text: $message)
                .padding(EdgeInsets(top: 10, leading: 18, bottom: 0, trailing: 4))
            HStack (alignment: .top) {

                if let image {
                    Image(uiImage: image)
                        .scaledToFit()
                        .frame(height: 181)
                        .padding(.trailing, 18)
                }
            }
            Spacer().frame(height:240)
        }
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.navigationBarTrailing) {
                SubmitButton()
            }
            ToolbarItemGroup(placement: .bottomBar) {
                CameraButton()
                AlbumButton()
            }
        }
        .fullScreenCover(isPresented: $isPresenting) {
            ImagePicker(sourceType: $sourceType, image: $image)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    @ViewBuilder
    func SubmitButton() -> some View {
        Button {
            Task{
               print("hello")
            }
    } label: {
        Image(systemName: "paperplane")
    }
}

@ViewBuilder
func CameraButton() -> some View {
    Button {
        sourceType = .camera
        isPresenting.toggle()
    } label: {
        Image(systemName: "iphone.rear.camera")
            .padding(EdgeInsets(top: 0, leading: 60, bottom: 20, trailing: 0))
            .scaleEffect(1.2)
    }
}

@ViewBuilder
func AlbumButton() -> some View {
    Button {
        sourceType = .photoLibrary
        isPresenting.toggle()
    } label: {
        Image(systemName: "photo.on.rectangle.angled")
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 60))
            .scaleEffect(1.2)
    }
}

}
