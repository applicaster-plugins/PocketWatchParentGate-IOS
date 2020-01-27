//
//  PushService.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 25.01.2020.
//

import Foundation
import FirebaseInstanceID

protocol PushService {
    
    func subscribePush()
    
    func unsubscribePush()
}

class FirebasePushService: PushService {
        
    func subscribePush() {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching instance ID: \(error.localizedDescription)")
            }
        }
    }
    
    func unsubscribePush() {
        InstanceID.instanceID().deleteID { error in
            if let error = error {
                print("Error deleting instance ID: \(error.localizedDescription)")
            }
        }
    }
}
