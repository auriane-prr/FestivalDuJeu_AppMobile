//
//  ParticiperZoneView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 16/03/2024.
//

import SwiftUI

struct ParticiperZoneView: View {
    @StateObject private var festivalModel = FestivalViewModel()
    @StateObject private var zoneModel = ZoneViewModel()
    @State private var currentDate = Date()

    let heures = ["9-11", "11-14", "14-17", "17-20", "20-22"]
    
    let customColor = UIColor(red: 29/255, green: 36/255, blue: 75/255, alpha: 0.8)

    var body: some View {
        NavigationView {
            VStack {
                if festivalModel.latestFestival != nil {
                    Picker("Sélectionnez une date", selection: $festivalModel.selectedDate) {
                        ForEach(festivalModel.selectableDates, id: \.self) { date in
                            Text(formatDate(date: date))
                                .tag(date)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 350, height: 200, alignment: .center)
                    .clipped()
                    .padding(.bottom, -50)
                    .padding(.top, -30)
                    .onReceive(festivalModel.$selectedDate) { newValue in
                        zoneModel.fetchZonesByDate(date: newValue)
                        currentDate = newValue
                    }
                    List {
                        ForEach(heures, id: \.self) { heure in
                            Section(header: Text(heure).font(.headline)) {
                                ForEach(zoneModel.zonesDisponiblesPourHeure(date: currentDate, heure: heure)) { zone in
                                    NavigationLink(destination: DetailZoneView(zone: zone, selectedHeure: heure)) {
                                        HStack {
                                            Text(zone.nomZone)
                                            Spacer()
                                            JaugeView(capaciteTotale: zone.horaireCota.first(where: { $0.heure == heure })?.nbBenevole ?? 0,
                                                                                              nombreInscrits: zone.horaireCota.first(where: { $0.heure == heure })?.listeBenevole?.count ?? 0)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .onAppear {
                festivalModel.loadLatestFestival()
            }
            .navigationTitle("Inscription Zone")
            
        }
    }

    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.string(from: date)
    }
}
