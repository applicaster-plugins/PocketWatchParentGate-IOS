//
//  Problems.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 03.01.2020.
//

import Foundation

struct Problems {
    
    var problems: [ProblemItem]?
    
    private lazy var bundle: Bundle = {
        return Bundle(for: PocketWatchParentGate.self)
    }()
    
    init() {
        if let url = bundle.url(forResource: "problems", withExtension: "json"), let jsonData = try? Data(contentsOf: url) {
            let jsonDecoder = JSONDecoder()
            do {
                problems = try jsonDecoder.decode([ProblemItem].self, from: jsonData)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
