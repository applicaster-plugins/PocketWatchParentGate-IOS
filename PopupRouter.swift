//
//  PopupPresenter.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 27.12.2019.
//

import Foundation

class PopupRouter {
    
    enum PopupType: String {
        case questions, getNotified, warning, notifications
    }
    
    var completion: (() -> Void)?
    
    private weak var presentingViewController: UIViewController?
    
    private var bundle: Bundle
    
    private lazy var storyboard: UIStoryboard = {
        return UIStoryboard(name: "PopupStoryboard", bundle: bundle)
    }()

    init(rootViewController: UIViewController, bundle: Bundle) {
        presentingViewController = rootViewController
        self.bundle = bundle
    }
    
    func present(with type: PopupType) {
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
            }
            popup.enableCompletion = { [weak popup] in
                popup?.removeChild()
                self.present(with: .questions)
            }
        case .getNotified:
            guard let popup = popupViewController as? GetNotifiedViewController else { break }
            popup.yesCompletion = { [weak popup] in
                popup?.removeChild()
                self.present(with: .notifications)
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
        }
    }
}
