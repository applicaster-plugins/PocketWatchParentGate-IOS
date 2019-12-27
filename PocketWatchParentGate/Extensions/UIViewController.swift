//
//  UIViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 24.12.2019.
//

import Foundation

extension UIViewController {
    
    func addChild(viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.frame
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func removeChild() {
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
