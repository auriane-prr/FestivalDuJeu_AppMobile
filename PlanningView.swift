//
//  PlanningView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct PlanningView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @ObservedObject var planningModel = PlanningViewModel()
    @ObservedObject var benevoleModel = BenevoleViewModel()
    
    var body: some View {
        VStack {
            if planningModel.isLoading {
                ProgressView()
            } else if let errorMessage = planningModel.errorMessage {
                Text(errorMessage)
            } else {
                let items = convertToItems(stands: planningModel.standsPlanning, zones: planningModel.zonesPlanning)
                let groupedItems = Dictionary(grouping: items, by: { $0.date })
                let sortedDates = groupedItems.keys.sorted()
                
                List {
                    ForEach(sortedDates, id: \.self) { date in
                        Section(header: Text(formatDate(date: date))) {
                            ForEach(groupedItems[date] ?? [], id: \.id) { item in
                                switch item.type {
                                case .stand(let stand):
                                    VStack {
                                        Text("Stand: \(stand.nomStand)")
                                        Text("date : \(formatDate(date: stand.date))")
                                        ForEach(stand.horaireCota, id: \.id) { horaire in
                                            Text("horaire : \(horaire.heure)")
                                        }
                                    }
                                case .zone(let zone):
                                    VStack {
                                        Text("Zone: \(zone.nomZone)")
                                        Text("date : \(formatDate(date: zone.date))")
                                        ForEach(zone.horaireCota, id: \.id) { horaire in
                                            Text("horaire : \(horaire.heure)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            self.fetchBenevoleData()
        }
    }
    
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.string(from: date)
    }
    
    private func fetchBenevoleData() {
        benevoleModel.getBenevoleId(pseudo: authModel.username) { benevoleId in
            guard let benevoleId = benevoleId else {
                print("Impossible de récupérer l'ID du bénévole.")
                return
            }
            planningModel.fetchStandsForBenevole(benevoleId: benevoleId)
            planningModel.fetchZonesForBenevole(benevoleId: benevoleId)
        }
    }
}

