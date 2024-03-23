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
    var animationRequise: Bool
    let lien: String?
    let logo: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nomJeu = "nom_jeu"
        case editeur, type, ageMin, duree, theme, mecanisme, tags, description, recu, nbJoueurs, animationRequise, lien, logo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        nomJeu = try container.decode(String.self, forKey: .nomJeu)
        editeur = try container.decode(String.self, forKey: .editeur)
        type = try container.decode(String.self, forKey: .type)
        ageMin = try container.decodeIfPresent(String.self, forKey: .ageMin)
        duree = try container.decodeIfPresent(String.self, forKey: .duree)
        theme = try container.decodeIfPresent(String.self, forKey: .theme)
        mecanisme = try container.decodeIfPresent(String.self, forKey: .mecanisme)
        tags = try container.decodeIfPresent(String.self, forKey: .tags)
        description = try container.decode(String.self, forKey: .description)
        recu = try container.decode(Bool.self, forKey: .recu)
        nbJoueurs = try container.decode(String.self, forKey: .nbJoueurs)
        let animationRequiseString = try container.decode(String.self, forKey: .animationRequise)
        animationRequise = animationRequiseString.lowercased() == "true" || animationRequiseString == "1"
        lien = try container.decodeIfPresent(String.self, forKey: .lien)
        logo = try container.decodeIfPresent(String.self, forKey: .logo)
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

struct ZoneJeu: Identifiable {
    let id = UUID() // Identifiant unique pour conformer à Identifiable
    let nomJeu: String
    let nomZone: String
}

