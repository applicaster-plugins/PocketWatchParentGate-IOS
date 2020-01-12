//
//  PocketWatchParentGate.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 21.12.2019.
//

import Foundation
import ZappPlugins
import AirshipKit

@objc public class PocketWatchParentGate: NSObject, ZPAppLoadingHookProtocol {
    
    public var configurationJSON: NSDictionary?
    
    public required init(configurationJSON: NSDictionary?) {
        self.configurationJSON = configurationJSON
    }

    public required override init() {
        
    }

    // MARK: - ZPAdapterProtocol implementation
    /*
     This protocol should be implemented by plugin that need to add some logic before application load data and before rootViewController presented. example: login plugin will implement this inteface in order to make login flow before application data launched.
     
     All the methods in this protocol are optional, implement only the necessary ones.
     */
    
    /*
     This method called after Plugins loaded locally, but the account load failed
     */
    @objc public func executeOnFailedLoading(completion: (() -> Void)?) {
        //Write you implementation here
        
        //Release the hook
        completion?()
    }
    
    /*
     This method called after Plugins loaded, and also after initial account data retrieved, you can add logic that not related to the application data.
     */
    @objc public func executeOnLaunch(completion: (() -> Void)?) {
        //Write you implementation here
        
        //Release the hook
        completion?()
    }
    
    /*
     This method called after all the data loaded and before viewController presented.
     */
    @objc public func executeOnApplicationReady(displayViewController: UIViewController?, completion: (() -> Void)?) {
        
        let parentGateViewController = ParentGateViewController()
        parentGateViewController.modalPresentationStyle = .fullScreen
        
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            //Release the hook
            completion?()
            return
        }
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .notDetermined {
                    displayViewController?.present(parentGateViewController, animated: true, completion: nil)
                    parentGateViewController.completion = {
                        //Release the hook
                        completion?()
                    }
                } else {
                    //Release the hook
                    if let push = UAirship.push() {
                        push.userPushNotificationsEnabled = settings.authorizationStatus == .authorized
                    }
                    
                    completion?()
                }
            }
        }
    }
    
    /*
     This method called after viewController is presented.
     */
    @objc public func executeAfterAppRootPresentation(displayViewController: UIViewController?, completion: (() -> Void)?) {
        //Write you implementation here
        
        //Release the hook
        completion?()
    }
    
    /*
     This method called when the application:continueUserActivity:restorationHandler is called.
     */
    @objc public func executeOnContinuingUserActivity(_ userActivity: NSUserActivity?, completion: (() -> Void)?) {
        //Write you implementation here
        
        //Release the hook
        completion?()
    }
}
