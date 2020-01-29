//
//  ControlNotificationsPopupRouter.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 19.01.2020.
//

import Foundation

class NotificationsPopupRouter: PopupRouter {
    
    var configurationJSON: NSDictionary?
    
    var notificationsEnabled = false
    
    var completion: (() -> Void)?
    
    var presentingViewController: UIViewController?
    
    var initialPopupType: PopupType = .questions
    
    private var bundle: Bundle
    
    private lazy var storyboard: UIStoryboard = {
        return UIStoryboard(name: "PopupStoryboard", bundle: bundle)
    }()
    
    required init(rootViewController: UIViewController? = nil, bundle: Bundle? = nil, configuration: NSDictionary? = nil) {
        presentingViewController = rootViewController
        self.bundle = bundle ?? Bundle.main
        configurationJSON = configuration
    }
    
    func present(with type: PopupType?) {
        let type = type ?? (notificationsEnabled ? .questions : .warning)
        let popupViewController = storyboard.instantiateViewController(withIdentifier: type.rawValue)
        presentingViewController?.addChild(viewController: popupViewController, animated: true)
        
        switch type {
        case .questions:
            guard let popup = popupViewController as? QuestionPopupViewController else { break }
            popup.noCompletion = {
                self.notificationsEnabled = false
                self.completion?()
            }
            popup.submitCompletion = { [weak popup] result in
                popup?.removeChild(animated: true)
                self.present(with: .getNotified)
            }
        case .warning:
            guard let popup = popupViewController as? WarningViewController else { break }
            popup.okCompletion = {
                self.presentAlert(title: nil, message: PopupRouterConstants.disableNotificationsTitle, actionTitle: PopupRouterConstants.notificationsActionTitle) { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    self.completion?()
                }
            }
            popup.enableCompletion = {
                self.notificationsEnabled = true
                self.completion?()
            }
        case .getNotified:
            guard let popup = popupViewController as? GetNotifiedViewController else { break }
            popup.viewPrivacyCompletion = {
                self.present(modalWith: .privacy)
            }
            popup.yesCompletion = { [weak popup] _ in
                let center = UNUserNotificationCenter.current()
                center.getNotificationSettings { settings in
                    DispatchQueue.main.async {
                        if settings.authorizationStatus == .notDetermined {
                            popup?.removeChild(animated: true)
                            self.present(with: .notifications)
                        } else {
                            self.presentAlert(title: nil, message: PopupRouterConstants.enableNotificationsTitle, actionTitle: PopupRouterConstants.notificationsActionTitle) { _ in
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                self.completion?()
                            }
                        }
                    }
                }
            }
            popup.noCompletion = {
                self.notificationsEnabled = false
                self.completion?()
            }
        case .notifications:
            guard let popup = popupViewController as? NotificationsViewController else { break }
            popup.okCompletion = {
                self.completion?()
            }
        default:
            break
        }
    }
    
    func present(modalWith type: PopupType?) {
        let type = type ?? initialPopupType
        switch type {
        case .privacy:
            guard let popupViewController = storyboard.instantiateViewController(withIdentifier: type.rawValue) as? PrivacyViewController else { break }
            if let privacyUrl = configurationJSON?[ConfigurationKey.privacyUrl.rawValue] as? String {
                popupViewController.privacyUrl = privacyUrl
            }
            presentingViewController?.present(popupViewController, animated: true, completion: nil)
        default:
            break
        }
    }
}
