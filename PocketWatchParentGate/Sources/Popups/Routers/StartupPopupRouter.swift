//
//  PopupPresenter.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 27.12.2019.
//

import Foundation

class StartupPopupRouter: PopupRouter {
    
    var configurationJSON: NSDictionary?
    
    var completion: (() -> Void)?
    
    weak var presentingViewController: UIViewController?
    
    var initialPopupType: PopupType = .questions
    
    private var bundle: Bundle
    
    private lazy var storyboard: UIStoryboard = {
        return UIStoryboard(name: "PopupStoryboard", bundle: bundle)
    }()
    
    private var previousPopupType: PopupType?

    required init(rootViewController: UIViewController? = nil, bundle: Bundle? = nil, configuration: NSDictionary? = nil) {
        presentingViewController = rootViewController
        self.bundle = bundle ?? Bundle.main
        configurationJSON = configuration
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func present(with type: PopupType?) {
        let type = type ?? initialPopupType
        let popupViewController = storyboard.instantiateViewController(withIdentifier: type.rawValue)
        presentingViewController?.addChild(viewController: popupViewController, animated: true)
        
        switch type {
        case .questions:
            guard let popup = popupViewController as? QuestionPopupViewController else { break }
            popup.noCompletion = { [weak popup] in
                popup?.removeChild(animated: true)
                self.present(with: .warning)
                self.previousPopupType = type
            }
            popup.submitCompletion = { [weak popup] result in
                popup?.removeChild(animated: true)
                self.present(with: .getNotified)
                self.previousPopupType = type
            }
        case .warning:
            guard let popup = popupViewController as? WarningViewController else { break }
            popup.okCompletion = {
                self.presentAlert(title: nil, message: PopupRouterConstants.disableNotificationsTitle, actionTitle: PopupRouterConstants.notificationsActionTitle) { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
            popup.enableCompletion = { [weak popup] in
                popup?.removeChild(animated: true)
                if let previousPopupType = self.previousPopupType {
                    self.present(with: previousPopupType)
                } else {
                    self.completion?()
                }
                self.previousPopupType = type
            }
        case .getNotified:
            guard let popup = popupViewController as? GetNotifiedViewController else { break }
            popup.viewPrivacyCompletion = {
                self.present(modalWith: .privacy)
                self.previousPopupType = type
            }
            popup.yesCompletion = { [weak popup] granted in
                if granted {
                    popup?.removeChild(animated: true)
                    self.present(with: .notifications)
                } else {
                    popup?.noCompletion?()
                }
                self.previousPopupType = type
            }
            popup.noCompletion = { [weak popup] in
                popup?.removeChild(animated: true)
                self.present(with: .warning)
                self.previousPopupType = type
            }
        case .notifications:
            guard let popup = popupViewController as? NotificationsViewController else { break }
            popup.okCompletion = {
                self.completion?()
                self.previousPopupType = type
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

extension StartupPopupRouter {
    
    @objc private func didBecomeActive(notification: Notification) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus != .authorized {
                    self.completion?()
                }
            }
        }
    }
}
