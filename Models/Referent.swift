//
//  Referent.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import Foundation

struct Referent: Codable, Identifiable {
    let id: String
    let pseudo: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case pseudo
    }
}
