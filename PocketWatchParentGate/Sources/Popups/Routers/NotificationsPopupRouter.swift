//
//  ControlNotificationsPopupRouter.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 19.01.2020.
//

import Foundation

class NotificationsPopupRouter: PopupRouter {
    
    var notificationsEnabled = false
    
    var completion: (() -> Void)?
    
    var presentingViewController: UIViewController?
    
    var initialPopupType: PopupType = .questions
    
    private var bundle: Bundle
    
    private lazy var storyboard: UIStoryboard = {
        return UIStoryboard(name: "PopupStoryboard", bundle: bundle)
    }()
    
    required init(rootViewController: UIViewController? = nil, bundle: Bundle) {
        presentingViewController = rootViewController
        self.bundle = bundle
    }
    
    func present(with type: PopupType?) {
        let type = type ?? (notificationsEnabled ? .questions : .warning)
        let popupViewController = storyboard.instantiateViewController(withIdentifier: type.rawValue)
        presentingViewController?.addChild(viewController: popupViewController)
        
        switch type {
        case .questions:
            guard let popup = popupViewController as? QuestionPopupViewController else { break }
            popup.noCompletion = {
                self.notificationsEnabled = false
                self.completion?()
            }
            popup.submitCompletion = { [weak popup] result in
                popup?.removeChild()
                self.present(with: .getNotified)
            }
        case .warning:
            guard let popup = popupViewController as? WarningViewController else { break }
            popup.okCompletion = {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                self.completion?()
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
                            popup?.removeChild()
                            self.present(with: .notifications)
                        } else {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            self.completion?()
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
            let popupViewController = storyboard.instantiateViewController(withIdentifier: type.rawValue)
            presentingViewController?.present(popupViewController, animated: true, completion: nil)
        default:
            break
        }
    }
}
