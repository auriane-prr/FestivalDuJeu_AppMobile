//
//  Stand.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import Foundation

struct Stand: Codable, Identifiable {
    let id: String
    let referents: [Referent] // Les ID des référents
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
