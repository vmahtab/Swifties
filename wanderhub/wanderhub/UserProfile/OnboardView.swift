//
//  Onboard.swift
//  wanderhub
//
//  Created by Neha Tiwari on 3/24/24.
//

import SwiftUI

struct Onboard: View {
    @State private var mountainButton = false // State variable to track button press
    @State private var beachButton = false
    @State private var jungleButton = false
    @State private var ratingButton = false
    @State private var campingButton = false
    @State private var lakeButton = false
    @State private var continueButton = false
    
    
    @Binding var signinProcess: Bool
    
    var body: some View {
        VStack(spacing: 41) {
            VStack(spacing: 10) {
                Text("Hello \(User.shared.username ?? "User")")
                    .font(Font.custom("Poppins", size: 26).weight(.semibold))
                    .foregroundColor(Color(red: 25/255, green: 52/255, blue: 82/255))
                Text("What do you like to do?")
                    .font(Font.custom("Poppins", size: 25).weight(.medium))
                    .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
            }
            .frame(maxWidth: .infinity)
            ZStack() {
                
                Button(action: {
                    // Action to perform when button is pressed
                    self.mountainButton.toggle()
                }) {
                    VStack(spacing: 10) {
                        Image("Mountains")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 82, height: 82)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6)
                        
                        Text("Mountain")
                            .font(Font.custom("Cabin", size: 16).weight(.medium))
                            .lineSpacing(25.60)
                            .foregroundColor(self.mountainButton ? Color(red: 0, green: 0.15, blue: 0.71) : Color(red: 0.12, green: 0.16, blue: 0.22))
                    }
                }
                .padding(10)
                .frame(width: 102, height: 138)
                .offset(x: -80, y: -146.50)
                Button(action: {
                    // Action to perform when button is pressed
                    self.beachButton.toggle()
                }) {
                    
                    VStack(spacing: 10) {
                        HStack(spacing: 0) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 82, height: 82)
                                .background(
                                    Image("Shore")
                                        .resizable()
                                        .scaledToFit()                                    )
                        }
                        .frame(width: 82, height: 82)
                        .background(Color(red: 1, green: 1, blue: 1))
                        .cornerRadius(8)
                        .shadow(
                            color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                        )
                        Text("Beach")
                            .font(Font.custom("Cabin", size: 16).weight(.medium))
                            .lineSpacing(25.60)
                            .foregroundColor(self.beachButton ? Color(red: 0, green: 0.15, blue: 0.71) : Color(red: 0.12, green: 0.16, blue: 0.22))
                        
                    }
                }
                .padding(10)
                .frame(width: 102, height: 138)
                .offset(x: 80, y: -146.50)
                
                Button(action: {
                    // Action to perform when button is pressed
                    self.jungleButton.toggle()
                }) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 0) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 82, height: 80)
                                .background(
                                    Image("Forest")
                                        .resizable()
                                        .scaledToFit()                                    )
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                        .frame(width: 82)
                        .background(Color(red: 1, green: 1, blue: 1))
                        .cornerRadius(8)
                        .shadow(
                            color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                        )
                        Text("Jungle Safa")
                            .font(Font.custom("Cabin", size: 16).weight(.medium))
                            .lineSpacing(25.60)
                            .foregroundColor(self.jungleButton ? Color(red: 0, green: 0.15, blue: 0.71) : Color(red: 0.12, green: 0.16, blue: 0.22))
                    }
                }
                .padding(10)
                .frame(width: 102, height: 138)
                .offset(x: -80, y: 0.50)
                
                Button(action: {
                    // Action to perform when button is pressed
                    self.ratingButton.toggle()
                }) {
                    
                    VStack(spacing: 10) {
                        HStack(spacing: 0) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 82.06, height: 82)
                                .background(
                                    Image("Boats")
                                        .resizable()
                                        .scaledToFit()                                    )
                        }
                        .frame(width: 82, height: 82)
                        .background(Color(red: 1, green: 1, blue: 1))
                        .cornerRadius(8)
                        .shadow(
                            color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                        )
                        Text("Rafting")
                            .font(Font.custom("Cabin", size: 16).weight(.medium))
                            .lineSpacing(25.60)
                            .foregroundColor(self.ratingButton ? Color(red: 0, green: 0.15, blue: 0.71) : Color(red: 0.12, green: 0.16, blue: 0.22))
                    }
                    
                }                  .padding(10)
                    .frame(width: 102, height: 138)
                    .offset(x: 80, y: 0.50)
                Button(action: {
                    // Action to perform when button is pressed
                    self.campingButton.toggle()
                }) {
                    
                    
                    VStack(spacing: 10) {
                        HStack(spacing: 0) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 82, height: 82)
                                .background(
                                    Image("Camp")
                                        .resizable()
                                        .scaledToFit()                                    )
                        }
                        .frame(width: 82, height: 82)
                        .background(Color(red: 1, green: 1, blue: 1))
                        .cornerRadius(8)
                        .shadow(
                            color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                        )
                        Text("Camping")
                            .font(Font.custom("Cabin", size: 16).weight(.medium))
                            .lineSpacing(25.60)
                            .foregroundColor(self.campingButton ? Color(red: 0, green: 0.15, blue: 0.71) : Color(red: 0.12, green: 0.16, blue: 0.22))
                    }
                    
                    
                }                  .padding(10)
                    .frame(width: 102, height: 138)
                    .offset(x: -80, y: 146.50)
                
                Button(action: {
                    // Action to perform when button is pressed
                    self.lakeButton.toggle()
                }) {
                    
                    
                    VStack(spacing: 10) {
                        HStack(spacing: 0) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 82, height: 82)
                                .background(
                                    Image("Greenland")
                                        .resizable()
                                        .scaledToFit()                                    )
                                .rotationEffect(.degrees(-180))
                        }
                        .frame(width: 82, height: 82)
                        .background(Color(red: 1, green: 1, blue: 1))
                        .cornerRadius(8)
                        .shadow(
                            color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                        )
                        Text("Lake")
                            .font(Font.custom("Cabin", size: 16).weight(.medium))
                            .lineSpacing(25.60)
                            .foregroundColor(self.lakeButton ? Color(red: 0, green: 0.15, blue: 0.71) : Color(red: 0.12, green: 0.16, blue: 0.22))
                    }
                    
                    
                }                  .padding(10)
                    .frame(width: 102, height: 138)
                    .offset(x: 80, y: 146.50)
            }
            .frame(width: 262, height: 431)
            
            Button(action: {
                // Action to perform when button is pressed
                //self.continueButton.toggle()
                signinProcess.toggle()
                
            }) {
                VStack(spacing: 10) {
                    Image("arrow_right")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                
            }     
            .frame(maxWidth: .infinity)
        }
        .padding(EdgeInsets(top: 147, leading: 49, bottom: 146, trailing: 50))
        .frame(width: 393, height: 852)
        .background(Color(red: 0.98, green: 0.97, blue: 0.93))
        
    }
}
