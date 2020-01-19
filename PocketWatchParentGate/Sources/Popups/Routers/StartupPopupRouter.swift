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

    required init(rootViewController: UIViewController? = nil, bundle: Bundle) {
        presentingViewController = rootViewController
        self.bundle = bundle
    }
    
    func present(with type: PopupType?) {
        let type = type ?? initialPopupType
        let popupViewController = storyboard.instantiateViewController(withIdentifier: type.rawValue)
        presentingViewController?.addChild(viewController: popupViewController)
        
        switch type {
        case .questions:
            guard let popup = popupViewController as? QuestionPopupViewController else { break }
            popup.noCompletion = { [weak popup] in
                popup?.removeChild()
                self.present(with: .warning)
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
            popup.enableCompletion = { [weak popup] in
                popup?.removeChild()
                self.present(with: .questions)
            }
        case .getNotified:
            guard let popup = popupViewController as? GetNotifiedViewController else { break }
            popup.viewPrivacyCompletion = {
                self.present(modalWith: .privacy)
            }
            popup.yesCompletion = { [weak popup] granted in
                if granted {
                    popup?.removeChild()
                    self.present(with: .notifications)
                } else {
                    popup?.noCompletion?()
                }
            }
            popup.noCompletion = { [weak popup] in
                popup?.removeChild()
                self.present(with: .warning)
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
