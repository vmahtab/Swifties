//
//  SignUp.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username: String = "Traveller"
    @State private var password: String = "funtravel"
    var user = User.shared
    @Binding var signinProcess: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("Find your next trip")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(titleCol)
            
            TextField("Enter name", text: $username)
                .foregroundColor(greyCol)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                        .foregroundColor(greyCol)
                )
                .padding(.horizontal, 40)
            
            SecureField("Enter password", text: $password)
                .foregroundColor(greyCol)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                        .foregroundColor(greyCol)
                )
                .padding(.horizontal, 40)
            
            Button("Sign Up") {
                // TODO: PUT THIS BACK INSIDE ONCE CONNECTED WITH BACKEND
                Task {
                    await user.signup(username: username, password: password)
                }
                signinProcess.toggle()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(backCol)
            .cornerRadius(10)
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backCol)
        .edgesIgnoringSafeArea(.all)
    }
}
