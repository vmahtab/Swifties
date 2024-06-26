//
//  SigninView.swift
//  swiftUIChatter
//
//  Created by Alexey Kovalenko on 2/29/24.
//

import SwiftUI


struct SigninView: View {
    @Binding var isPresented: Bool
    @State private var signupActive = false
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    private let user = User.shared
    @State private var showAlert = false
    @State private var loginFailed = false
    
    func login() {
        if username.isEmpty || password.isEmpty {
            showAlert = true
            return
        }
        Task {
            do {
                if let _ = await user.signin(username: username, password: password) {
                    isPresented.toggle()
                } else {
                    loginFailed = true
                }
            }
        }
        
    }
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 200)
            Text("Login to Find your Best Trip")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(titleCol)
            
            TextField("Enter name", text: $username)
                .autocapitalization(.none)
                .foregroundColor(greyCol)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                        .foregroundColor(greyCol)
                )
                .padding(.horizontal, 40)
            
            SecureField("Enter password", text: $password)
                .autocapitalization(.none)
                .foregroundColor(greyCol)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                        .foregroundColor(greyCol)
                )
                .padding(.horizontal, 40)
            
            Button("Login") {
                login()
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
//            Spacer()
//                .frame(height: 20)
            NavigationLink(destination: SignUpView(signinProcess: $isPresented)){
                Text("Sign Up")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(backCol)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            Spacer()
                         .frame(height: 20)
            NavigationLink(destination: SignUpView(signinProcess: $isPresented)){
                Button {
                        Task {
                            if let _ = await user.signin(username: "testing", password: "testing") {
                                isPresented.toggle()
                            }
                        }
                    } label: {
                        VStack {
                            Image("demo_arrrow")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("Start Demo")
                                .foregroundColor(titleCol)
                        }
                    }
            }
            Spacer()
        }
        .onAppear {
	            if let usertoken = UserDefaults.standard.string(forKey: "usertoken") {
                isPresented.toggle()
            }
        }
    }
}
