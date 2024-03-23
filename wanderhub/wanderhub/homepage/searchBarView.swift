//
//  searchBarView.swift
//  wanderhub
//
//  Created by Neha Pinnu on 3/23/24.
//

import SwiftUI

struct SearchBarViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SearchBar {
        return SearchBar()
    }
    
    func updateUIViewController(_ uiViewController: SearchBar, context: Context) {
    }
    
}
