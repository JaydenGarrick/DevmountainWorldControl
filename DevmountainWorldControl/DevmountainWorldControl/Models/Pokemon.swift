//
//  Pokemon.swift
//  DevmountainWorldControl
//
//  Created by Jayden Garrick on 3/10/21.
//

import Foundation

struct TopLevelJSON: Codable {
    let cards: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let hp: String?
    let rarity: String?
    let lowResolutionImageURL: URL
    let highResolutionImageURL: URL
    let set: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case hp
        case rarity
        case lowResolutionImageURL = "imageUrl"
        case highResolutionImageURL = "imageUrlHiRes"
        case set
    }
}
