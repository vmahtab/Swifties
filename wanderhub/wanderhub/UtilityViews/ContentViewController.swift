//
//  ContentViewController.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//
import SwiftUI

enum ViewState {
    case itinerary
    case map
    case landmark
    case profile
    case home
}

class ViewController: ObservableObject {
    static let shared = ViewController()
    var viewstate: ViewState
    
    private init() {
        viewstate = ViewState.home
    }
    
    
}
