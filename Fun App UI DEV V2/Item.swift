//
//  Item.swift
//  Cultural Bridge Quest
//
//  Created by Kaushik Manian on 19/6/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

