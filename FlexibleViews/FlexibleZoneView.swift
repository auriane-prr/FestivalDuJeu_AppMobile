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
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    let heures = ["9-11", "11-14", "14-17", "17-20", "20-22"]
    
    let customColor = Color(UIColor(red: 29/255, green: 36/255, blue: 75/255, alpha: 0.8))

    var body: some View {
        Text("Flexible Zone")
                           .font(.largeTitle)
                           .padding(.bottom, 20)
                           .padding(.top, 20)
        
        Form {
            Section(header : Text("Sélectionne une date : ")) {
                if let _ = festivalModel.latestFestival {
                    Picker("Sélectionnez une date", selection: $festivalModel.selectedDate) {
                        ForEach(festivalModel.selectableDates, id: \.self) { date in
                            Text(formatDate(date: date)).tag(date)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onReceive(festivalModel.$selectedDate) { newValue in
                        zoneModel.fetchZonesByDate(date: newValue)
                        currentDate = newValue
                    }
                } else {
                    ProgressView().onAppear {
                        festivalModel.loadLatestFestival()
                    }
                }
            }
            
            Section(header: Text("Sélectionne un horaire :")) {
                Picker("", selection: $selectedHeure.onChange(clearSelectedZones)) {
                    ForEach(heures, id: \.self) { heure in
                        Text(heure).tag(heure as String?)
                    }
                }
                    .frame(maxWidth: .infinity)
            }

            
            Section(header: Text("Sélectionne une ou plusieures zones : ")) {
                if !zoneModel.zonesDisponiblesPourHeure(date: currentDate, heure: selectedHeure ?? "9-11").isEmpty {
                    ForEach(zoneModel.zonesDisponiblesPourHeure(date: currentDate, heure: selectedHeure ?? "9-11"), id: \.id) { zone in
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
                                    JaugeView(capaciteTotale: zone.horaireCota.first(where: { $0.heure == selectedHeure ?? "9-11" })?.nbBenevole ?? 0,
                                              nombreInscrits: zone.horaireCota.first(where: { $0.heure == selectedHeure ?? "9-11" })?.listeBenevole?.count ?? 0)
                                
                            }
                        }
                        .foregroundColor(.primary)
                    }
                } else {
                    Text("Pas de zone disponible à cet horaire.")
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
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(customColor)
                        .cornerRadius(8)
                }
                .alert(isPresented: $showingAlert) {
                            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                        .padding(.top, 20)
        
        .navigationBarTitleDisplayMode(.inline)
        
        }
    

    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.string(from: date)
    }

    private func clearSelectedZones(_ newHour: String?) {
        selectedZoneIds.removeAll()
    }
}

#Preview{
    FlexibleZoneView()
}

