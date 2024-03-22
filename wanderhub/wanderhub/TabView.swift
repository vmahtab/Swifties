//
//  TabView.swift
//  wanderhub
//
//  Created by Vivianna Mahtab on 3/22/24.
//

import Foundation
import SwiftUI

struct PlacesView: View {
    
    var body: some View {
        
        HStack() {
            
            VStack() {
            }.safeAreaInset(edge: VerticalEdge.bottom) {
                Button {
                } label: {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                }
                .padding()
                .foregroundStyle(.gray)
                
            }
            
            VStack() {
            }.safeAreaInset(edge: VerticalEdge.bottom) {
                Button {
                } label: {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .frame(width: 28.0, height: 32.0)
                }
                .padding()
                .foregroundStyle(.gray)
                
            }
            
            VStack() {
            }.safeAreaInset(edge: VerticalEdge.bottom) {
                Button {
                } label: {
                    Image(systemName: "pencil.and.list.clipboard")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                }
                .padding()
                .foregroundStyle(.gray)
            }
        }
    }

