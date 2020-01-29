//
//  Configurable.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 29.01.2020.
//

import Foundation

enum ConfigurationKey: String {
    case privacyUrl = "privacy_url_key"
}

protocol Configurable {
    
    var configurationJSON: NSDictionary? { get set }
}
