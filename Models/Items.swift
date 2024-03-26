//
//  Items.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 25/03/2024.
//

import Foundation

struct Items: Identifiable {
    let id: String
    let name: String
    let date: Date
    let type: ItemType
    let horaire : String

    // Computed property to access horaireCota
    var horaireCota: [HoraireCota] {
        switch type {
        case .stand(let stand):
            return stand.horaireCota
        case .zone(let zone):
            return zone.horaireCota
        }
    }
}

enum ItemType {
    case stand(StandPlanning)
    case zone(ZonePlanning)
}


func convertToItems(stands: [StandPlanning], zones: [ZonePlanning]) -> [Items] {
    var items: [Items] = []
    
    for stand in stands {
        for horaire in stand.horaireCota {
            let item = Items(id: "\(stand.id)-\(horaire.id)", name: stand.nomStand, date: stand.date, type: .stand(stand), horaire: horaire.heure)
            items.append(item)
        }
    }
    
    for zone in zones {
        for horaire in zone.horaireCota {
            let item = Items(id: "\(zone.id)-\(horaire.id)", name: zone.nomZone, date: zone.date, type: .zone(zone), horaire: horaire.heure)
            items.append(item)
        }
    }
    
    return items
}
