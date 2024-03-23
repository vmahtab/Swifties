//
//  StartupPage.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//

import SwiftUI

struct StartupPage: View {
    @State private var isActive = false
    @State var SigninPresented = true
    
    var body: some View {
        NavigationView{
            VStack {
                if isActive {
                    SigninView(isPresented: $SigninPresented)
                } else {
                    Spacer()
                    Text("WanderHub")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
