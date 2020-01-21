//
//  PocketWatchParentGate.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 21.12.2019.
//

import Foundation
import ZappPlugins
import AirshipKit

@objc public class PocketWatchParentGate: NSObject, ZPAppLoadingHookProtocol, ZPPluggableScreenProtocol {
    
    public static var bundle = Bundle(for: PocketWatchParentGate.self)
    
    public var configurationJSON: NSDictionary?
    
    public var screenPluginDelegate: ZPPlugableScreenDelegate?
    
    private let firsAppLaunchKey = "PocketWatchParentGate.firsAppLaunchKey"
        
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
        
        let parentGateViewController = ParentGateViewController(router: StartupPopupRouter(bundle: Self.bundle))
        parentGateViewController.modalPresentationStyle = .fullScreen
        
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            //Release the hook
            completion?()
            return
        }
                
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined || !UserDefaults.standard.bool(forKey: self.firsAppLaunchKey) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        DispatchQueue.main.async {
                            UAirship.push()?.userPushNotificationsEnabled = settings.authorizationStatus == .authorized
                            if settings.authorizationStatus == .authorized {
                                displayViewController?.present(parentGateViewController, animated: true, completion: nil)
                                parentGateViewController.completion = {
                                    UserDefaults.standard.set(true, forKey: self.firsAppLaunchKey)
                                    //Release the hook
                                    completion?()
                                }
                            } else {
                                //Release the hook
                                completion?()
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    //Release the hook
                    UAirship.push()?.userPushNotificationsEnabled = settings.authorizationStatus == .authorized
                    
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
    
    // MARK: - ZPPluggableScreenProtocol implementation
    
    public required init?(pluginModel: ZPPluginModel, screenModel: ZLScreenModel, dataSourceModel: NSObject?) {
        super.init()
    }
    
    public func createScreen() -> UIViewController {
        let storyboard = UIStoryboard(name: "ControlNotificationsStoryboard", bundle: Self.bundle)
        return storyboard.instantiateInitialViewController() ?? UIViewController()
    }
}
