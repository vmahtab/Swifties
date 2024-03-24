//
//  File.swift
//  wanderhub
//
//  Created by Neha Tiwari on 3/23/24.
//

import Foundation
import SwiftUI

struct UserProfileView: View {
    var body: some View {
        ZStack {
            HStack(spacing: 100) {
                Text("Hello John")
                    .font(Font.custom("Poppins", size: 26).weight(.semibold))
                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
            }
            .offset(x: 0, y: 20)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 12) {
                    Text("Settings")
                        .font(Font.custom("Poppins", size: 16).weight(.medium))
                        .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                }
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 16))
                .frame(width: 343)
                .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.20)
                        .stroke(Color(red: 0.74, green: 0.74, blue: 0.74), lineWidth: 0.20)
                )
                HStack(spacing: 12) {
                    Text("Settings")
                        .font(Font.custom("Poppins", size: 16).weight(.medium))
                        .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                }
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 16))
                .frame(width: 343)
                .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.20)
                        .stroke(Color(red: 0.74, green: 0.74, blue: 0.74), lineWidth: 0.20)
                )
                HStack(spacing: 12) {
                    Text("Settings")
                        .font(Font.custom("Poppins", size: 16).weight(.medium))
                        .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                }
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 16))
                .frame(width: 343)
                .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.20)
                        .stroke(Color(red: 0.74, green: 0.74, blue: 0.74), lineWidth: 0.20)
                )
                // Add other menu items here (Preferences, FAQs, etc.)
            }
            .frame(width: 356, height: 170)
            .background(Color(red: 0.94, green: 0.92, blue: 0.87))
            .cornerRadius(10)
            .offset(x: -1.50, y: -161)
            
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 20) {
                    // Replace placeholders with actual profile data
                    ProfileItemView(title: "Yosemite Westlake Camping Resort", date: "October 8th - 11th", imageURL: "https://via.placeholder.com/80x80")
                    ProfileItemView(title: "White Shore Lake", date: "December 20th - 25th", imageURL: "https://via.placeholder.com/80x80")
                    // Add more profile items here
                }
            }
            .offset(x: 0.50, y: 88)
            
            Text("Past Trips:")
                .font(Font.custom("Poppins", size: 16).weight(.medium))
                .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                .offset(x: -135.50, y: -47)
        }
        .frame(width: 393, height: 852)
        .background(Color(red: 0.98, green: 0.97, blue: 0.93))
    }
}

struct ProfileItemView: View {
    let title: String
    let date: String
    let imageURL: String
    
    var body: some View {
        HStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Font.custom("Cabin", size: 14).weight(.semibold))
                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                Text(date)
                    .font(Font.custom("Cabin", size: 12))
                    .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))
            }
            .frame(maxWidth: .infinity)
            AsyncImage(url: URL(string: imageURL))
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .shadow(color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6)
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .frame(width: 370)
        .background(Color(red: 0.94, green: 0.92, blue: 0.87))
        .cornerRadius(8)
        .shadow(color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6)
    }
}

#Preview {
    UserProfileView()
}
