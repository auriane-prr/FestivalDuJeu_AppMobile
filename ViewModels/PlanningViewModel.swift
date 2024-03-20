//
//  PlanningViewModel.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 20/03/2024.
//

import Foundation

class PlanningViewModel: ObservableObject {
    
    @Published var standsPlanning: [StandPlanning] = []
    @Published var zonesPlanning: [ZonePlanning] = []
    
    @Published var creneaux: [Creneau] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchStandsForBenevole(benevoleId: String) {
            guard let url = URL(string: "https://festivaldujeuback.onrender.com/stands/benevole/\(benevoleId)") else {
                DispatchQueue.main.async {
                    self.errorMessage = "URL invalide pour récupérer les stands du bénévole."
                }
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            // Ajoutez ici d'autres headers si nécessaire, par exemple pour l'authentification

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

            isLoading = true

            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                defer { DispatchQueue.main.async { self?.isLoading = false } }
                
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Erreur réseau ou données non reçues."
                    }
                    return
                }

                do {
                    let stands = try decoder.decode([StandPlanning].self, from: data)
                    DispatchQueue.main.async {
                        self?.standsPlanning = stands
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Erreur de décodage : \(error.localizedDescription)"
                    }
                }
            }
            task.resume()
        }

    func fetchZonesForBenevole(benevoleId: String) {
            guard let url = URL(string: "https://festivaldujeuback.onrender.com/zoneBenevole/benevole/\(benevoleId)") else {
                DispatchQueue.main.async {
                    self.errorMessage = "URL invalide pour récupérer les zones du bénévole."
                }
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            // Ajoutez ici d'autres headers si nécessaire, par exemple pour l'authentification

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

            isLoading = true

            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                defer { DispatchQueue.main.async { self?.isLoading = false } }
                
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Erreur réseau ou données non reçues."
                    }
                    return
                }

                do {
                    let zones = try decoder.decode([ZonePlanning].self, from: data)
                    DispatchQueue.main.async {
                        self?.zonesPlanning = zones
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Erreur de décodage : \(error.localizedDescription)"
                    }
                }
            }
            task.resume()
        }
    }
