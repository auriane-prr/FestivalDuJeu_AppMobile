//
//  Festival.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import Foundation

struct Festival: Codable, Identifiable {
    let id: String
    let nom: String
    let lieu: String
    let description: String
    let dateDebut: Date
    let dateFin: Date

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nom, lieu, description, dateDebut = "date_debut", dateFin = "date_fin"
    }
}
