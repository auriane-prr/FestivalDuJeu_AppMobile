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
    func getBenevoleId(pseudo: String, completion: @escaping (String?) -> Void) {
        print("je suis dans func getBenevoleId")
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        guard let urlFetchId = URL(string: "https://festivaldujeuback.onrender.com/benevole/pseudo/\(pseudo)") else {
            print("URL invalide pour récupérer l'ID.")
            DispatchQueue.main.async {
                self.errorMessage = "URL invalide pour récupérer l'ID."
            }
            return
        }
        
        print("URL: \(urlFetchId.absoluteString)")
        
        var requestFetchId = URLRequest(url: urlFetchId)
        requestFetchId.httpMethod = "GET"
        requestFetchId.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: requestFetchId) { [weak self] data, response, error in
            if let error = error {
                print("Erreur réseau : \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.errorMessage = "Erreur lors de la récupération de l'ID utilisateur : \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                print("Réponse invalide du serveur.")
                DispatchQueue.main.async {
                    self?.errorMessage = "Réponse invalide du serveur lors de la récupération de l'ID."
                }
                return
            }
            
            print("Code de statut HTTP : \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200 {
                print("Réponse invalide du serveur : Statut \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    self?.errorMessage = "Réponse invalide du serveur : Statut \(httpResponse.statusCode)"
                }
                return
            }
            
            let jsonStr = String(data: data, encoding: .utf8)
            print("Raw JSON string: \(jsonStr ?? "Invalid JSON")")
            
            do {
                let response = try JSONDecoder().decode(BenevoleResponse.self, from: data)
                let benevoleId = response.benevole._id
                print("benevoleId : \(benevoleId)")
                DispatchQueue.main.async {
                    completion(benevoleId) // Appeler le callback avec l'ID
                }
            } catch {
                print("Erreur lors du décodage : \(error)")
                DispatchQueue.main.async {
                    self?.errorMessage = "Erreur lors du décodage de la réponse : \(error.localizedDescription)"
                    completion(nil) // En cas d'erreur, appeler le callback avec nil
                }
            }
        }.resume()
    }

            
            func participerAuStand(idBenevole: String, idHoraire: String, completion: @escaping (Bool, String?) -> Void) {
                print("id horaire : \(idHoraire)")
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
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        completion(false, "Réponse invalide du serveur.")
                        return
                    }

                    completion(true, nil)  // Succès
                }.resume()
            }

}
