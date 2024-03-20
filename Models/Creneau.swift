//
//  Creneau.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 20/03/2024.
//

import Foundation

struct Creneau: Identifiable {
    var id: String // Peut être l'ID du stand ou de la zone
    var nom: String // Nom du stand ou de la zone
    var heure: String // Heure du créneau
    var type: CreneauType // Type pour distinguer stand et zone

    enum CreneauType {
        case stand(Stand)
        case zone(Zone)
    }
}

