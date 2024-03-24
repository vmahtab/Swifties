//
//  ContentViewController.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//
import SwiftUI

struct ChildNavController: View {
    @ObservedObject var viewModel: NavigationControllerViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.viewState = .home
                viewModel.isPresented = false
            } label: {
                Image(systemName: "house")
                    .font(.system(size: 30))
                    .padding(.vertical, 15)
                    .padding(.horizontal, 20)
            }
            Button {
                viewModel.viewState = .itinerary
                viewModel.isPresented = true
            } label: {
                Image(systemName: "list.bullet")
                    .font(.system(size: 30))
                    .padding(.vertical, 15)
                    .padding(.horizontal, 20)
            }
            Button {
                viewModel.viewState = .map
                viewModel.isPresented = true
            } label: {
                Image(systemName: "safari")
                    .font(.system(size: 30))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
            }
            Button {
                viewModel.viewState = .landmark
                viewModel.isPresented = true
            } label: {
                Image(systemName: "camera")
                    .font(.system(size: 30))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
            }
            Button {
                viewModel.viewState = .profile
                viewModel.isPresented = true
            } label: {
                Image(systemName: "person")
                    .font(.system(size: 30))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
            }
        }
        .background(navBarCol)
        .frame(height: 50)
        .foregroundColor(.black)
    }
}

