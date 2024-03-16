//
//  Jeu.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 16/03/2024.
//

import Foundation

struct Jeu: Codable, Identifiable {
    let id: String 
    let nomJeu: String
    let editeur: String
    let type: String
    let ageMin: String?
    let duree: String?
    let theme: String?
    let mecanisme: String?
    let tags: String?
    let description: String
    let recu: Bool
    let nbJoueurs: String
    let animationRequise: String
    let lien: String?
    let logo: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id" 
        case nomJeu = "nom_jeu"
        case editeur
        case type
        case ageMin = "ageMin"
        case duree
        case theme
        case mecanisme
        case tags
        case description
        case recu
        case nbJoueurs = "nbJoueurs"
        case animationRequise = "animation_requise"
        case lien
        case logo
    }
}

struct JeuID: Codable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.id = try container.decode(String.self)
    }
}
