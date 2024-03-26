//
//  FlexibleStandView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 19/03/2024.
//

import SwiftUI

struct FlexibleStandView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @StateObject private var festivalModel = FestivalViewModel()
    @StateObject private var standModel = StandViewModel()
    @StateObject private var benevoleModel = BenevoleViewModel()
    @StateObject private var flexibleModel = FlexibleViewModel()
    
    @State private var currentDate = Date()

    @State private var selectedStandIds: Set<String> = []
    @State private var selectedHeure: String? = nil
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    let heures = ["9-11", "11-14", "14-17", "17-20", "20-22"]
    
    let customColor = Color(UIColor(red: 29/255, green: 36/255, blue: 75/255, alpha: 0.8))

    var body: some View {
        
        Text("Flexible Stand")
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
                        standModel.fetchStandsByDate(date: newValue)
                        currentDate = newValue
                    }
                } else {
                    ProgressView().onAppear {
                        festivalModel.loadLatestFestival()
                    }
                }
            }
            
            Section(header: Text("Sélectionne un horaire :")) {
                Picker(selection: $selectedHeure, label: Text("")) {
                            Text("Aucune").tag(String?.none)
                            ForEach(heures, id: \.self) { heure in
                                Text(heure).tag(heure as String?)
                            }
                        }
                    .frame(maxWidth: .infinity)
            }

            
            Section(header: Text("Sélectionne un ou plusieurs stands : ")) {
                if !standModel.standsDisponiblesPourHeure(date: currentDate, heure: selectedHeure ?? "9-11").isEmpty {
                    ForEach(standModel.standsDisponiblesPourHeure(date: currentDate, heure: selectedHeure ?? "9-11"), id: \.id) { stand in
                        Button(action: {
                            if selectedStandIds.contains(stand.id) {
                                selectedStandIds.remove(stand.id)
                            } else {
                                selectedStandIds.insert(stand.id)
                            }
                        }) {
                            HStack {
                                Image(systemName: selectedStandIds.contains(stand.id) ? "checkmark.square" : "square")
                                    Text(stand.nomStand)
                                    JaugeView(capaciteTotale: stand.horaireCota.first(where: { $0.heure == selectedHeure ?? "9-11" })?.nbBenevole ?? 0,
                                              nombreInscrits: stand.horaireCota.first(where: { $0.heure == selectedHeure ?? "9-11" })?.listeBenevole?.count ?? 0)
                                
                            }
                        }
                        .foregroundColor(.primary)
                    }
                } else {
                    Text("Pas de stand disponible à cet horaire.")
                }
            }

        }
        
                Button(action: {
                    benevoleModel.getBenevoleId(pseudo: authModel.username) { benevoleId in
                        guard let benevoleId = benevoleId else {
                            print("Impossible de récupérer l'ID du bénévole.")
                            return
                        }

                        guard let selectedHeure = selectedHeure else {
                            print("Informations requises pour ajouter un bénévole flexible manquantes")
                            return
                        }

                        let selectedDate = DateFormatter.iso8601Full.string(from: festivalModel.selectedDate)

                        if selectedDate.isEmpty {
                            print("La date sélectionnée est invalide")
                            return
                        }

                        let horairesStands = selectedStandIds.map { standId -> FlexibleStand in
                            return FlexibleStand(date: selectedDate, heure: selectedHeure, listeStand: [standId])
                        }

                        flexibleModel.ajouterFlexibleAuStand(benevoleId: benevoleId, horaires: horairesStands) { success, message in
                                if success {
                                    self.alertTitle = "Succès"
                                    self.alertMessage = "Votre flexibilité a bien été enregistrée."
                                } else {
                                    self.alertTitle = "Erreur"
                                    self.alertMessage = message ?? "Une erreur est survenue."
                                }
                                DispatchQueue.main.async {
                                    self.showingAlert = true
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
    
    private func clearSelectedStands(_ newHour: String?) {
            selectedStandIds.removeAll()
        }
    
}


#Preview{
    FlexibleStandView()
}
