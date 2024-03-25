//
//  UserProfileView.swift
//  wanderhub
//
//  Created by Neha Tiwari on 3/24/24.
//

import SwiftUI
import Foundation
import SwiftUI

struct UserProfileView: View {
    // @StateObject private var userHistoryStore = UserHistoryStore()
    //   @State private var landmarkVisits: [LandmarkVisit] = []
    private let userHistory = UserHistoryStore.shared
    @State private var landmarkVisits: [LandmarkVisit]
    
    var body: some View {
        ZStack() {
            VStack(alignment: .trailing, spacing: 0) {
                HStack(spacing: 12) {
                    Text("   Settings")
                        .font(Font.custom("Poppins", size: 16).weight(.medium))
                        .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 16))
                .frame(width: 343)
                .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                .cornerRadius(10)
                
                HStack(spacing: 12) {
                    Text("   Preferences")
                        .font(Font.custom("Poppins", size: 16).weight(.medium))
                        .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 16))
                .frame(width: 343)
                .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                
                HStack(spacing: 12) {
                    Text("   FAQs")
                        .font(Font.custom("Poppins", size: 16).weight(.medium))
                        .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                        .frame(maxWidth: .infinity, alignment: .leading) //
                }
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 16))
                .frame(width: 343)
                .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                .cornerRadius(10)
            }
            .frame(width: 356, height: 170)
            .background(Color(red: 0.94, green: 0.92, blue: 0.87))
            .cornerRadius(10)
            .offset(x: -1.50, y: -161)
            HStack(spacing: 161) {
                Text("Hello \(User.shared.username ?? "User")")
                    .font(Font.custom("Poppins", size: 26).weight(.semibold))
                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                    .frame(maxWidth: .infinity, alignment: .leading) //
            }
            .frame(width: 352, height: 39)
            .offset(x: 0.50, y: -299.50)
            VStack(){
                Text("    Past Landmarks:")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                    .offset(x: -135.50, y: -47)
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(landmarkVisits, id: \.landmarkName) { landmarkVisit in
                            
                            HStack {
                                // Customize your landmark display here
                                Text("\(landmarkVisit.landmarkName)")
                                    .font(Font.custom("Poppins", size: 14).weight(.semibold))
                                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                                
                                Spacer()
                                
                                Text("\(landmarkVisit.city), \(landmarkVisit.country)")
                                    .font(Font.custom("Poppins", size: 14))
                                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                                Spacer()
                                
                                Text("\(landmarkVisit.city), \(landmarkVisit.country)")
                                    .font(Font.custom("Poppins", size: 14))
                                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                            }
                            .padding()
                            .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                            .cornerRadius(8)
                            .shadow(color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6)
                        }
                    }
                }
                .padding()
            }
            
            
        }
        
        
        .frame(width: 393, height: 852)
        .background(Color(red: 0.98, green: 0.97, blue: 0.93))
        
        .onAppear {
            fetchLandmarkVisits()
        }
    }
    
    private func fetchLandmarkVisits() {
        Task {
            if let history = await UserHistoryStore.shared.getHistory(),
               let visits = UserHistoryStore.shared.parseLandmarkVisits(from: history) {
                self.landmarkVisits = visits
            }
        }
    }
}



//
//#Preview {
//    UserProfileView()
//}

//HStack(spacing: 24) {
//    HStack(spacing: 0) {
//        Rectangle()
//            .foregroundColor(.clear)
//            .frame(width: 80, height: 79.94)
//            .background(
//                Image("Mountains")
//                        .resizable()
//                        .scaledToFit()
//            )
//    }
//    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0.06, trailing: 0))
//    .frame(width: 80, height: 80)
//    .background(Color(red: 1, green: 1, blue: 1))
//    .cornerRadius(8)
//    .shadow(
//        color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
//    )
//    VStack(alignment: .leading, spacing: 2) {
//        HStack(spacing: 0) {
//            HStack(alignment: .top, spacing: 38) {
//                Text("Bell Tower")
//                    .font(Font.custom("Cabin", size: 14).weight(.semibold))
//                    .lineSpacing(22.40)
//                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//        .frame(width: 234)
//    }
//    .frame(maxWidth: .infinity)
//}
//.padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
//.frame(width: 370, height: 96)
//.background(Color(red: 0.94, green: 0.92, blue: 0.87))
//.cornerRadius(8)
//.shadow(
//    color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
//)
//.offset(x:0, y:80)
