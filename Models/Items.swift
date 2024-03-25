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
}

enum ItemType {
    case stand(StandPlanning)
    case zone(ZonePlanning)
}


// Conversion des stands et zones en Items
func convertToItems(stands: [StandPlanning], zones: [ZonePlanning]) -> [Items] {
    let standItems = stands.map { Items(id: $0.id, name: $0.nomStand, date: $0.date, type: .stand($0)) }
    let zoneItems = zones.map { Items(id: $0.id, name: $0.nomZone, date: $0.date, type: .zone($0)) }
    
    return standItems + zoneItems
}
