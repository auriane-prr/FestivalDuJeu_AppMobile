//
//  ParticiperView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct ParticiperStandView: View {
    @StateObject private var festivalModel = FestivalViewModel()
    @StateObject private var standModel = StandViewModel()
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
                        standModel.fetchStandsByDate(date: newValue)
                        currentDate = newValue
                    }
                    List {
                        ForEach(heures, id: \.self) { heure in
                            Section(header: Text(heure).font(.headline)) {
                                ForEach(standModel.standsDisponiblesPourHeure(date: currentDate, heure: heure)) { stand in
                                    NavigationLink(destination: DetailStandView(stand: stand, selectedHeure : heure)) {
                                        HStack {
                                            Text(stand.nomStand)
                                            Spacer()
                                            JaugeView(capaciteTotale: stand.horaireCota.first(where: { $0.heure == heure })?.nbBenevole ?? 0,
                                                                                              nombreInscrits: stand.horaireCota.first(where: { $0.heure == heure })?.listeBenevole?.count ?? 0)
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
            .navigationTitle("Inscription Stand")
            
        }
    }

    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.string(from: date)
    }
}

