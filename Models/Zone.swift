//
//  Zone.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 16/03/2024.
//

import Foundation

struct Zone: Codable, Identifiable {
    let id: String
    let nomZoneBenevole: String
    let referents: [Referent]
    let idZoneBenevole: String
    let date: Date
    let listeJeux: [Jeu] 
    let horaireCota: [HoraireCota]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nomZoneBenevole = "nom_zone_benevole"
        case referents
        case idZoneBenevole = "id_zone_benevole"
        case date
        case listeJeux = "liste_jeux"
        case horaireCota
    }
}
