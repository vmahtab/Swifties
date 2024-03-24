//
//  SignUp.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username: String?
    @State private var password: String?
    @State private var email: String?
    var user = User.shared
    @Binding var signinProcess: Bool
    
    @State private var showAlert = false
    @State private var loginFailed = false
    
    func signup() {
        guard let username = username, !username.isEmpty,
              let password = password, !password.isEmpty,
              let email = email, !email.isEmpty else {
            showAlert = true
            return
        }
        Task {
            do {
                if let _ = await user.signup(username: username, password: password, email: email) {
                    signinProcess.toggle()
                    presentationMode.wrappedValue.dismiss()
                } else {
                    loginFailed = true
                }
            }
        }
        
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Find your next trip")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(titleCol)
            
            TextField("Enter name", text: Binding(
                get: { username ?? "" },
                set: { username = $0.isEmpty ? nil : $0 }
            ))
                .foregroundColor(greyCol)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                        .foregroundColor(greyCol)
                )
                .padding(.horizontal, 40)
            
            SecureField("Enter password", text: Binding(get: {password ?? ""},
                                                        set: {password = $0.isEmpty ? nil : $0}))
                .foregroundColor(greyCol)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                        .foregroundColor(greyCol)
                )
                .padding(.horizontal, 40)
            
            TextField("Enter Email", text: Binding(
                get: { email ?? "" },
                set: { email = $0.isEmpty ? nil : $0 }
            ))
                .foregroundColor(greyCol)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                        .foregroundColor(greyCol)
                )
                .padding(.horizontal, 40)
            
            Button("Sign Up") {
                signup()
//                signinProcess.toggle()
//                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(backCol)
            .cornerRadius(10)
            .padding(.horizontal, 40)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Username and password cannot be empty"), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $loginFailed) {
                Alert(title: Text("Error"), message: Text("Login Failed"), dismissButton: .default(Text("OK")))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backCol)
        .edgesIgnoringSafeArea(.all)
    }
}
