//
//  WanderHubID.swift
//  swiftUIChatter
//
//  Created by Alexey Kovalenko on 2/29/24.
//


// TODO: IMPLEMENT FOR MVP SO WE CAN STORE PREVIOUS LOGIN IN THE KEYCHAIN

import Foundation
import LocalAuthentication

final class WanderHubID {
    static let shared = WanderHubID() // create one instance of the class to be shared
    private init(){}                // and make the constructor private so no other
                                    // instances can be created
    #if targetEnvironment(simulator)
        private let auth = LAContext()
    #endif
    private var _id: String?
    
    
    var expiration = Date(timeIntervalSince1970: 0.0)

    var id: String? {
        get { Date() >= expiration ? nil : _id }
        set(newValue) { _id = newValue }
    }
    
    
    func delete() async {
        let item: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrDescription: "WanderHubID",
        ]
        
        let delStatus = SecItemDelete(item as CFDictionary)
        if (delStatus != 0) {
            print("WanderHubID.delete: \(String(describing: SecCopyErrorMessageString(delStatus, nil)!))")
        }
    }
    
    func save() async {
        #if targetEnvironment(simulator)
            guard let _ = try? await auth.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "to allow simulator to access WanderHubID in KeyChain") else { return }
        #endif
        let df = DateFormatter()
        df.dateFormat="yyyy-MM-dd HH:mm:ss '+'SSSS"
        
        let item: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrDescription: "WanderHubID",
        ]
        
        let updates: [CFString: Any] = [
            kSecValueData: id?.data(using: .utf8) as Any,
            kSecAttrLabel: df.string(from: expiration)
        ]
        
        // Try to update the item first
            var updateStatus = SecItemUpdate(item as CFDictionary, updates as CFDictionary)
            
            if updateStatus == errSecItemNotFound {
                // If the item wasn't found, try to add it
                var newItem = item
                newItem[kSecValueData] = id?.data(using: .utf8) as Any
                newItem[kSecAttrLabel] = df.string(from: expiration)
                
                updateStatus = SecItemAdd(newItem as CFDictionary, nil)
                
                if updateStatus != errSecSuccess {
                    print("WanderHubID.save (add): \(String(describing: SecCopyErrorMessageString(updateStatus, nil)!))")
                }
            } else if updateStatus != errSecSuccess {
                print("WanderHubID.save (update): \(String(describing: SecCopyErrorMessageString(updateStatus, nil)!))")
            }
    }
    
    func open() async {
        if expiration != Date(timeIntervalSince1970: 0.0) {
            // not first launch
            return
        }
        
        let searchFor: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrDescription: "WanderHubID",
            kSecReturnData: true,
            kSecReturnAttributes: true,
        ]
        
        var itemRef: AnyObject?
        let searchStatus = SecItemCopyMatching(searchFor as CFDictionary, &itemRef)
        
        let df = DateFormatter()
        df.dateFormat="yyyy-MM-dd HH:mm:ss '+'SSSS"
        
        switch (searchStatus) {
        case errSecSuccess: // found keychain
            if let item = itemRef as? NSDictionary,
               let data = item[kSecValueData] as? Data,
               let dateStr = item[kSecAttrLabel] as? String,
               let date = df.date(from: dateStr) {
                id = String(data: data, encoding: .utf8)
                expiration = date
            } else {
                print("Keychain has null entry!")
            }
        case errSecItemNotFound:
            // biometric check
            let accessControl = SecAccessControlCreateWithFlags(nil,
              kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
              .userPresence,
              nil)!
            //let item: [CFString: Any] = [
            let item = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrDescription: "WanderHubID",
                kSecAttrLabel: df.string(from: expiration), // trailing comma ok
                kSecAttrAccessControl: accessControl  // biometric check
            ] as CFDictionary
            
            let addStatus = SecItemAdd(item as CFDictionary, nil)
            if (addStatus != 0) {
                print("WanderHubID.open add: \(String(describing: SecCopyErrorMessageString(addStatus, nil)!))")
            }
        default:
            print("WanderHubID.open search: \(String(describing: SecCopyErrorMessageString(searchStatus, nil)!))")

        }
        #if targetEnvironment(simulator)
            guard let _ = try? await auth.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "to allow simulator to access WanderHubID in KeyChain") else { return }
        #endif
    }
}
