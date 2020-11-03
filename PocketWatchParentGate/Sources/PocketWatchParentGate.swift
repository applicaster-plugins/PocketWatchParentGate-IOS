//
//  PocketWatchParentGate.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 21.12.2019.
//

import Foundation
import ZappPlugins

@objc public class PocketWatchParentGate: NSObject, ZPAppLoadingHookProtocol, ZPPluggableScreenProtocol {
    
    public static var bundle: Bundle? = {
        if let path = Bundle.main.path(forResource: "PocketWatchParentGate", ofType: "bundle") {
            return Bundle(path: path)
        }
        return nil
    }()
    
    
    public var configurationJSON: NSDictionary?
    public var screenPluginDelegate: ZPPlugableScreenDelegate?
    
    static var pushService: PushService = FirebasePushService()
    private static var toastDisplayController: UIViewController? = nil
    
    private let firsAppLaunchKey = "PocketWatchParentGate.firsAppLaunchKey"
    private var parentGateViewController: UIViewController? = nil
    
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
        Self.toastDisplayController = displayViewController
        let debugCompletion: (() -> Void) = {
            #if DEBUG
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                completion?()
                self.parentGateViewController?.dismiss(animated: false, completion: nil)
                self.parentGateViewController?.dismiss(animated: false, completion: nil)
            }
            #else
            completion?()
            self.parentGateViewController?.dismiss(animated: false, completion: nil)
            #endif
        }
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined || !UserDefaults.standard.bool(forKey: self.firsAppLaunchKey) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        UNUserNotificationCenter.current().getNotificationSettings { settings in
                            DispatchQueue.main.async {
                                if settings.authorizationStatus == .authorized {
                                    self.showInitiallyAuthorizedFlow(displayViewController: displayViewController, completion: debugCompletion)
                                } else {
                                    //Release the hook
                                    debugCompletion()
                                    if(settings.authorizationStatus == .authorized) {
                                        Self.subscribePush()
                                    }  else {
                                        Self.unsubscribePush()
                                    }
                                }
                                
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    //Release the hook
                    settings.authorizationStatus == .authorized ? Self.subscribePush(withToast: true) : Self.unsubscribePush(withToast: true)
                    debugCompletion()
                }
            }
        }
    }
    
    static func subscribePush(withToast: Bool = true) {
        Self.pushService.subscribePush{ (result) in
            self.showDebugMessage(withToast: withToast,
                                  message: result ? "Firebase push subscribed successfully" : "Firebase push subscribe failed")
        }
    }
    
    static func unsubscribePush(withToast: Bool = true) {
        Self.pushService.unsubscribePush{ (result) in
            self.showDebugMessage(withToast: withToast,
                                  message: result ? "Firebase push unsubscribed successfully" : "Firebase push unsubscribe failed")
        }
    }
    
    private static func showDebugMessage(withToast: Bool, message: String) {
        #if DEBUG
        print(message)
        if (withToast) {
            Self.toastDisplayController?.showToast(message: message, seconds: 5, completion: {})
        }
        #endif
    }
    
    private func showInitiallyAuthorizedFlow(displayViewController: UIViewController?, completion: (() -> Void)?) {
        let viewController = ParentGateViewController(router: StartupPopupRouter(bundle: Self.bundle, configuration: self.configurationJSON))
        viewController.modalPresentationStyle = .fullScreen
        displayViewController?.present(viewController, animated: true, completion: nil)
        viewController.completion = {
            UserDefaults.standard.set(true, forKey: self.firsAppLaunchKey)
            //Release the hook
            completion?()
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if(settings.authorizationStatus == .authorized) {
                    Self.subscribePush()
                }  else {
                    Self.unsubscribePush()
                }
            }
        }
        self.parentGateViewController = viewController
        Self.toastDisplayController = viewController
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
        
        configurationJSON = pluginModel.configurationJSON
    }
    
    public func createScreen() -> UIViewController {
        let storyboard = UIStoryboard(name: "ControlNotificationsStoryboard", bundle: Self.bundle)
        let screen = storyboard.instantiateInitialViewController() as? ControlNotificationsViewController
        let router = NotificationsPopupRouter(bundle: PocketWatchParentGate.bundle, configuration: configurationJSON)
        screen?.popupRouter = router
        return screen ?? UIViewController()
    }
}
