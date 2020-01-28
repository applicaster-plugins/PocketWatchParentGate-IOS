//
//  PopupPresenter.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 27.12.2019.
//

import Foundation

class StartupPopupRouter: PopupRouter {
        
    var completion: (() -> Void)?
    
    weak var presentingViewController: UIViewController?
    
    var initialPopupType: PopupType = .questions
    
    private var bundle: Bundle
    
    private lazy var storyboard: UIStoryboard = {
        return UIStoryboard(name: "PopupStoryboard", bundle: bundle)
    }()
    
    private var previousPopupType: PopupType?

    required init(rootViewController: UIViewController? = nil, bundle: Bundle? = nil) {
        presentingViewController = rootViewController
        self.bundle = bundle ?? Bundle.main
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
                    self.completion?()
                }
                self.previousPopupType = type
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
            let popupViewController = storyboard.instantiateViewController(withIdentifier: type.rawValue)
            presentingViewController?.present(popupViewController, animated: true, completion: nil)
        default:
            break
        }
    }
}
