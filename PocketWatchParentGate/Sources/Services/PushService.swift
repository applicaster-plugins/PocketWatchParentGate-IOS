//
//  PushService.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 25.01.2020.
//

import Foundation
import FirebaseInstanceID

protocol PushService {
    
    func subscribePush(withCompletion: ((Bool) -> Void)?)
    
    func unsubscribePush(withCompletion: ((Bool) -> Void)?)
}

class FirebasePushService: PushService {
    
    func subscribePush(withCompletion: ((Bool) -> Void)?) {
        var completion = withCompletion
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                completion?(false)
                print("Error fetching instance ID: \(error.localizedDescription)")
            } else {
                completion?(true)
            }
        }
        //Timeout. Temporary solution before update to the new API
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion?(true)
            completion = nil
        }
    }
    
    func unsubscribePush(withCompletion: ((Bool) -> Void)?) {
        var completion = withCompletion
        InstanceID.instanceID().deleteID { error in
            if let error = error {
                completion?(false)
                print("Error deleting instance ID: \(error.localizedDescription)")
            } else {
                completion?(true)
            }
        }
        //Timeout. Temporary solution before update to the new API
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion?(true)
            completion = nil
        }
    }
}
