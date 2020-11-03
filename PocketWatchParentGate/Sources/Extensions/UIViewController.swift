//
//  UIViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 24.12.2019.
//

import Foundation

extension UIViewController {
    
    func addChild(viewController: UIViewController, animated: Bool = false) {
        addChild(viewController)
        viewController.view.frame = view.frame
        view.addSubview(viewController.view)
        
        if animated {
            viewController.view.alpha = 0
            UIView.animate(withDuration: 0.25, animations: {
                viewController.view.alpha = 1
            }) { finished in
                viewController.didMove(toParent: self)
            }
        } else {
            viewController.didMove(toParent: self)
        }
    }
    
    func removeChild(animated: Bool = false) {
        willMove(toParent: nil)
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.alpha = 0
            }) { finished in
                self.removeFromParent()
                self.view.removeFromSuperview()
                self.didMove(toParent: nil)
            }
        } else {
            removeFromParent()
            view.removeFromSuperview()
            didMove(toParent: nil)
        }
    }
    
    func showToast(message: String, seconds: Double, completion:@escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
            completion()
        }
    }
}
