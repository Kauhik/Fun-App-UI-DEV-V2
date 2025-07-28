//
//  PuzzleCategory.swift
//  Cultural Bridge Quest
//

import SwiftUI

struct PuzzleCategory: Transferable, Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let culturalMeaning: String
    var isMatched: Bool = false
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .text)
    }
}

extension PuzzleCategory: Codable {
    enum CodingKeys: String, CodingKey {
        case name, culturalMeaning, isMatched
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        culturalMeaning = try container.decode(String.self, forKey: .culturalMeaning)
        isMatched = try container.decode(Bool.self, forKey: .isMatched)
        color = .blue // Default color since Color isn't easily codable
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(culturalMeaning, forKey: .culturalMeaning)
        try container.encode(isMatched, forKey: .isMatched)
    }
}
