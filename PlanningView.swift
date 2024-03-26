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
    
    let heures = ["9-11", "11-14", "14-17", "17-20", "20-22"]

    var body: some View {
        VStack {
            if planningModel.isLoading {
                ProgressView()
            } else if let errorMessage = planningModel.errorMessage {
                Text(errorMessage)
            } else {
                let items = convertToItems(stands: planningModel.standsPlanning, zones: planningModel.zonesPlanning)
                let groupedItems = Dictionary(grouping: items, by: { $0.date }).mapValues { items in
                    items.sorted(by: { first, second in
                        heures.firstIndex(where: { $0 == first.horaireCota.first?.heure }) ?? 0 <
                        heures.firstIndex(where: { $0 == second.horaireCota.first?.heure }) ?? 0
                    })
                }
                
                let sortedDates = groupedItems.keys.sorted()
                
                List {
                            ForEach(sortedDates, id: \.self) { date in
                                Section(header: Text(formatDate(date: date))) {
                                    ForEach(groupedItems[date] ?? [], id: \.id) { item in
                                        HStack {
                                            Text("\(item.horaire) : ") 
                                            Text(item.name)
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
