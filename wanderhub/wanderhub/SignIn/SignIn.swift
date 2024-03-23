//
//  SigninView.swift
//  swiftUIChatter
//
//  Created by Alexey Kovalenko on 2/29/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct SigninView: View {
    @Binding var isPresented: Bool
    private let signinClient = GIDSignIn.sharedInstance
    
    func backendSignin(_ token: String?) {
        Task {
            if let _ = await User.shared.addUser(token) {
                // will save() chatterID later
                await WanderHubID.shared.save()
            }
            isPresented.toggle()
        }
    }
    
    var body: some View {
        VStack{
            if let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController {
                GoogleSignInButton {
                    signinClient.signIn(withPresenting: rootVC){ result, error in
                        if error != nil {
                            print("signIn: \(error!.localizedDescription)")
                        } else {
                            backendSignin(result?.user.idToken?.tokenString)
                        }
                    }
                }
                .frame(width:100, height:50, alignment: Alignment.center)
                .onAppear {
                    if let user = signinClient.currentUser {
                        backendSignin(user.idToken?.tokenString)
                    } else {
                        signinClient.restorePreviousSignIn { user, error in
                            if error != nil {
                                print("restorePreviousSignIn: \(error!.localizedDescription)")
                            } else {
                                backendSignin(user?.idToken?.tokenString)
                            }
                        }
                    }
                }
            }
            Button("Sign Up") {
                //SigninView(isPresented: $isPresented)
            }
        }
    }
}
