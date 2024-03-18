//
//  AccueilView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct AccueilView: View {
    @StateObject private var festivalModel = FestivalViewModel()
    @StateObject private var standModel = StandViewModel()
    @StateObject private var zoneModel = ZoneViewModel()
    @State private var currentDate = Date()
    @State private var currentType: String = "Stands"
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Type", selection: $currentType) {
                    Text("Stands").tag("Stands")
                    Text("Zones").tag("Zones")
                }
                .pickerStyle(.segmented)
                .padding()
                
                if festivalModel.latestFestival != nil {
                    Picker("Sélectionnez une date", selection: $festivalModel.selectedDate) {
                        ForEach(festivalModel.selectableDates, id: \.self) { date in
                            Text(formatDate(date: date)).tag(date)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    contentList()
                } else {
                    ProgressView().onAppear {
                        festivalModel.loadLatestFestival()
                    }
                }
            }
            .navigationTitle("Accueil")
            .onAppear {
                fetchCurrentSelection() // Charge les données initiales basées sur les valeurs par défaut
            }
            .onChange(of: currentType) { _ in
                fetchCurrentSelection() // Gère les changements de type
            }
            .onChange(of: festivalModel.selectedDate) { _ in
                fetchCurrentSelection() // Gère les changements de date
            }
        }
    }

    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }

    @ViewBuilder
    private func contentList() -> some View {
        List {
            if currentType == "Zones" {
                ForEach(zoneModel.zones, id: \.id) { zone in
                    Text(zone.nomZone)
                }
            } else if currentType == "Stands" {
                ForEach(standModel.stands, id: \.id) { stand in
                    Text(stand.nomStand)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func fetchCurrentSelection() {
        if currentType == "Zones" {
            zoneModel.fetchZonesByDate(date: festivalModel.selectedDate)
        } else {
            standModel.fetchStandsByDate(date: festivalModel.selectedDate)
        }
    }
}

