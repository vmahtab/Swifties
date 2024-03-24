//
//  StartupPage.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//

import SwiftUI

struct StartupPage: View {
    @State private var isActive = false
    @State private var SigninPresented: Bool = true

    
    var body: some View {
        NavigationView{
            VStack {
                if isActive {
                    if SigninPresented {
                        SigninView(isPresented: $SigninPresented)
                    } else {
                        HomeView()
                    }
                } else {
                    Spacer()
                    Text("WanderHub")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(titleCol)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backCol)
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
