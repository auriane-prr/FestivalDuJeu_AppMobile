//
//  FlexibleZoneView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 19/03/2024.
//

import SwiftUI

struct FlexibleZoneView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @StateObject private var festivalModel = FestivalViewModel()
    @StateObject private var zoneModel = ZoneViewModel()
    @StateObject private var benevoleModel = BenevoleViewModel()
    @State private var currentDate = Date()

    @State private var selectedZoneIds: Set<String> = []
    @State private var selectedHeure: String? = nil

    let heures = ["9-11", "11-14", "14-17", "17-20", "20-22"]

    var body: some View {
        NavigationView {
            VStack {
                if let _ = festivalModel.latestFestival {
                    Picker("Sélectionnez une date", selection: $festivalModel.selectedDate) {
                        ForEach(festivalModel.selectableDates, id: \.self) { date in
                            Text(formatDate(date: date)).tag(date)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .onReceive(festivalModel.$selectedDate) { newValue in
                        zoneModel.fetchZonesByDate(date: newValue)
                        currentDate = newValue
                    }

                    Picker("Sélectionnez une heure", selection: $selectedHeure) {
                        Text("Aucune").tag(String?.none)
                        ForEach(heures, id: \.self) { heure in
                            Text(heure).tag(heure as String?)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 150)
                    .clipped()

                    if let selectedHeure = selectedHeure {
                        // Sélection des zones
                        Text("Sélectionnez une ou plusieurs zones pour \(selectedHeure):")
                        ScrollView {
                            ForEach(zoneModel.zonesDisponiblesPourHeure(date: currentDate, heure: selectedHeure), id: \.id) { zone in
                                Button(action: {
                                    if selectedZoneIds.contains(zone.id) {
                                        selectedZoneIds.remove(zone.id)
                                    } else {
                                        selectedZoneIds.insert(zone.id)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: selectedZoneIds.contains(zone.id) ? "checkmark.square" : "square")
                                        Text(zone.nomZone)
                                    }
                                }
                                .foregroundColor(.primary)
                            }
                        }
                    } else {
                        Text("Veuillez sélectionner une heure.")
                    }
                } else {
                    ProgressView().onAppear {
                        festivalModel.loadLatestFestival()
                    }
                }

                // Affichage des sélections
                Text("Sélections :")

                if !selectedZoneIds.isEmpty {
                    Text("Zones Sélectionnées :")
                    ForEach(Array(selectedZoneIds), id: \.self) { id in
                        if let zone = zoneModel.zones.first(where: { $0.id == id }) {
                            Text(zone.nomZone)
                        }
                    }
                }
                Button(action: {
                    // Récupérez l'ID du bénévole
                    benevoleModel.getBenevoleId(pseudo: authModel.username) { benevoleId in
                        guard let benevoleId = benevoleId else {
                            print("Impossible de récupérer l'ID du bénévole.")
                            return
                        }

                        // Assurez-vous d'avoir l'heure et la date sélectionnées
                        guard let selectedHeure = selectedHeure else {
                            print("Informations requises pour ajouter un bénévole flexible manquantes")
                            return
                        }

                        let selectedDate = DateFormatter.iso8601Full.string(from: festivalModel.selectedDate)

                        if selectedDate.isEmpty {
                            print("La date sélectionnée est invalide")
                            return
                        }

                        // Créez les structures pour les horaires des zones
                        let horairesZones = selectedZoneIds.map { zoneId -> FlexibleZone in
                            return FlexibleZone(date: selectedDate, heure: selectedHeure, listeZone: [zoneId]) // Assurez-vous que la listeZone prend des ID sous forme de String
                        }

                        // Appel de la fonction ajouterFlexibleALaZone
                        benevoleModel.ajouterFlexibleALaZone(benevoleId: benevoleId, horaires: horairesZones) { success, message in
                            if success {
                                print("Succès de l'ajout aux zones")
                            } else {
                                print("Erreur lors de l'ajout aux zones: \(message ?? "Erreur inconnue")")
                            }
                        }
                    }
                }) {
                    Text("Enregistrer")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

            }
            .navigationTitle("Flexible")
        }
    }

    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}
