//
//  Zone.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 16/03/2024.
//

import Foundation

struct Zone: Codable, Identifiable {
    let id: String
    let nomZone: String
    let referents: [BenevoleId]?
    let idZone: String
    let date: Date
    let listeJeux: [JeuID]
    let horaireCota: [HoraireCota]

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Ajouté
        case nomZone = "nom_zone_benevole"
        case referents
        case idZone = "id_zone_benevole"
        case date
        case listeJeux = "liste_jeux"
        case horaireCota
    }
}
