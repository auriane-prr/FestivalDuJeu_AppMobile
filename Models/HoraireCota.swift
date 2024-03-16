//
//  HoraireCota.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 16/03/2024.
//

import Foundation

struct HoraireCota: Codable {
    let id: String // Ajoutez cette ligne
    let heure: String
    let nbBenevole: Int?
    let listeBenevole: [Referent]? // Modifié pour correspondre au type attendu d'identifiants

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Ajoutez cette ligne
        case heure
        case nbBenevole = "nb_benevole"
        case listeBenevole = "liste_benevole"
    }
}
