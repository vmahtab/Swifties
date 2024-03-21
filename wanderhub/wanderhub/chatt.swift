//
//  chatt.swift
//  wanderhub
//
//  Created by Neha Pinnu on 3/21/24.
//

import Foundation

struct Chatt {
    var username: String?
    var timestamp: String?
    @OptionalizedEmpty var imageUrl: String?
}

@propertyWrapper
struct OptionalizedEmpty {
    private var _value: String?
    var wrappedValue: String? {
        get { _value }
        set {
            guard let newValue else {
                _value = nil
                return
            }
            _value = (newValue == "null" || newValue.isEmpty) ? nil : newValue
        }
    }
    
    init(wrappedValue: String?) {
        self.wrappedValue = wrappedValue
    }
}
