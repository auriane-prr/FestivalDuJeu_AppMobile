//
//  Planning.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 20/03/2024.
//

import Foundation

struct ZonePlanning: Codable {
    let id: String
    let nomZone: String
    let referents: [String]
    let idZone: String
    let date: Date
    let listeJeux: [String]
    let horaireCota: [HoraireCota]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nomZone = "nom_zone_benevole"
        case referents
        case idZone = "id_zone_benevole"
        case date
        case listeJeux = "liste_jeux"
        case horaireCota
    }
}

struct StandPlanning: Codable, Identifiable {
    let id: String
    let referents: [String]
    let nomStand: String
    let description: String
    let date: Date
    let horaireCota: [HoraireCota]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case referents
        case nomStand = "nom_stand"
        case description
        case date
        case horaireCota
    }
}
