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
        pocketWatchParentGate?.executeOnApplicationReady(displayViewController: self, completion: { [weak self] in
            self?.pocketWatchParentGate = nil
        })
    }
    
    @IBAction func notificationSettingsClicked(_ sender: Any) {
    }
}

