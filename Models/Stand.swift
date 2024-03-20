//
//  Stand.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import Foundation

struct Stand: Codable, Identifiable {
    let id: String
    let referents: [BenevoleId] // Les ID des référents
    let nomStand: String
    let description: String
    let date: Date
    let horaireCota: [HoraireCota]

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Ajouté
        case referents
        case nomStand = "nom_stand"
        case description
        case date
        case horaireCota
    }
}


