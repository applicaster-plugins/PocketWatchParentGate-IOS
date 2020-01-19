//
//  Problems.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 03.01.2020.
//

import Foundation

struct Problems {
    
    var problems: [ProblemItem]?
        
    init() {
        if let url = PocketWatchParentGate.bundle.url(forResource: "problems", withExtension: "json"), let jsonData = try? Data(contentsOf: url) {
            let jsonDecoder = JSONDecoder()
            do {
                problems = try jsonDecoder.decode([ProblemItem].self, from: jsonData)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
