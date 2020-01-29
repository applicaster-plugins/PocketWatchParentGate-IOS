//
//  PrivacyViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 28.12.2019.
//

import UIKit
import WebKit

class PrivacyViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var privacyUrl = "https://pocket.watch/app/privacy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
}

extension PrivacyViewController {
    
    private func setupLayout() {
        
        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.load(URLRequest(url: URL(string: privacyUrl)!))
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        let views: [String: Any] = [
            "closeButton": closeButton!,
            "webView" : webView
        ]

        var allConstraints: [NSLayoutConstraint] = []

        let webViewHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-8-[webView]-8-|",
            metrics: nil,
            views: views
        )
        allConstraints += webViewHorizontalConstraints
                        
        let webViewVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[closeButton]-8-[webView]-8-|",
            metrics: nil,
            views: views
        )
        allConstraints += webViewVerticalConstraints
        
        NSLayoutConstraint.activate(allConstraints)
    }
}
