//
//  StandViewModel.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import Foundation

class StandViewModel: ObservableObject {

    @Published var stands: [Stand] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var selectedStandsPerHour: [String: [String]] = [:]
    
    func fetchStandsByDate(date: Date) {
        let dateString = DateFormatter.iso8601Full.string(from: date)
        print(dateString)
        guard let url = URL(string: "https://festivaldujeuback.onrender.com/stands/date/\(dateString)") else {
            DispatchQueue.main.async {
                self.errorMessage = "L'URL des stands est invalide."
            }
            return
        }

        isLoading = true
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Échec du chargement : \(error.localizedDescription)"
                    print("echec du chargement")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                    self?.errorMessage = "Réponse invalide du serveur."
                    print("réponse invalide du serveur")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .custom({ decoder -> Date in
                        let container = try decoder.singleValueContainer()
                        let dateString = try container.decode(String.self)
                        let formatter = ISO8601DateFormatter()
                        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                        if let date = formatter.date(from: dateString) {
                            return date
                        }
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format for ISO8601")
                    })
                    let stands = try decoder.decode([Stand].self, from: data)
                    self?.stands = stands
                } catch {
                    self?.errorMessage = "Échec de décodage : \(error.localizedDescription)"
                    print("echec de decodage")
                }
            }
        }
        task.resume()
    }
    
    func standsDisponiblesPourHeure(date: Date, heure: String) -> [Stand] {
        return stands.filter { stand in
            stand.date == date &&
            stand.horaireCota.contains { cota in
                cota.heure == heure && (cota.nbBenevole ?? 0) != 0 && (cota.listeBenevole?.count ?? 0) < (cota.nbBenevole ?? 0)
            }
        }
    }
            
            func participerAuStand(idBenevole: String, idHoraire: String, completion: @escaping (Bool, String?) -> Void) {
                let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
                guard let url = URL(string: "https://festivaldujeuback.onrender.com/stands/participer/\(idHoraire)/\(idBenevole)") else {
                    completion(false, "URL invalide pour l'inscription.")
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                URLSession.shared.dataTask(with: request) { _, response, error in
                    if let error = error {
                        completion(false, "Erreur lors de la participation : \(error.localizedDescription)")
                        print("Erreur lors de la participation : \(error.localizedDescription)")
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        completion(false, "Réponse invalide du serveur.")
                        print("Réponse invalide du serveur.")
                        return
                    }

                    completion(true, nil)
                    print("votre participation a été enregistré")
                }.resume()
            }


}
