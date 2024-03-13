//
//  Benevole.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import Foundation

struct Benevole: Codable {
    var admin: Bool
    var referent: Bool
    var nom: String
    var prenom: String
    var pseudo: String
    var password: String
    var association: String
    var taille_tshirt: String
    var vegetarien: Bool
    var mail: String
    var hebergement: String
    var adresse: String?
    var num_telephone: String?
}
