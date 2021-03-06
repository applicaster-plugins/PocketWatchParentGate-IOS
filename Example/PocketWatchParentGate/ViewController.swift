//
//  ViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 12/21/2019.
//  Copyright (c) 2019 Andrii Novoselskyi. All rights reserved.
//

import UIKit
import PocketWatchParentGate

class ViewController: UIViewController {
    
    var pocketWatchParentGate: PocketWatchParentGate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func executeOnStartupClicked(_ sender: Any) {
        pocketWatchParentGate = PocketWatchParentGate(configurationJSON: nil)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.pocketWatchParentGate?.executeOnApplicationReady(displayViewController: self, completion: { [weak self] in
                print("completion callback")
                self?.pocketWatchParentGate = nil
            })
        }
    }
    
    @IBAction func notificationSettingsClicked(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    @IBAction func controlNotificationClicked(_ sender: Any) {
        pocketWatchParentGate = PocketWatchParentGate(configurationJSON: nil)
        if let screen = pocketWatchParentGate?.createScreen() {
            present(screen, animated: true, completion: nil)
        }
    }
}

