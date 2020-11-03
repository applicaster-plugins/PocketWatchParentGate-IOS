//
//  PushService.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 25.01.2020.
//

import Foundation
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseCore

protocol PushService {
    
    func subscribePush(withCompletion: ((Bool) -> Void)?)
    
    func unsubscribePush(withCompletion: ((Bool) -> Void)?)
}

class FirebasePushService: PushService {
    
    func subscribePush(withCompletion: ((Bool) -> Void)?) {
        var completion = withCompletion
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
            completion?(false)
          } else {
            completion?(true)

          }
        }
    
        //Timeout.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion?(true)
            completion = nil
        }
    }
    
    func unsubscribePush(withCompletion: ((Bool) -> Void)?) {
        var completion = withCompletion
        Messaging.messaging().deleteData { error in
            if let error = error {
                completion?(false)
                print("Error deleting instance ID: \(error.localizedDescription)")
            } else {
                completion?(true)
            }
        }
        
        //Timeout.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion?(true)
            completion = nil
        }
    }
}
