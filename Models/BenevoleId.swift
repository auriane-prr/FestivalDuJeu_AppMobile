//
//  BenevoleId.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 20/03/2024.
//

import Foundation

struct BenevoleId: Codable, Identifiable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
}

struct BenevolePseudoResponse: Codable {
    let pseudo: String
}
