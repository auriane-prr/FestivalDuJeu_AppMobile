//
//  HoraireCota.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 16/03/2024.
//

import Foundation

struct HoraireCota: Codable {
    let id: String
    let heure: String
    let nbBenevole: Int?
    let listeBenevole: [BenevoleId]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id" 
        case heure
        case nbBenevole = "nb_benevole"
        case listeBenevole = "liste_benevole"
    }
}
