//
//  ZoneViewModel.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 16/03/2024.
//

import Foundation


class ZoneViewModel: ObservableObject {

    @Published var zones: [Zone] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var selectedZonesPerHour: [String: [String]] = [:]
    @Published var jeux: [Jeu] = []
    
    func fetchZonesByDate(date: Date) {
        let dateString = DateFormatter.iso8601Full.string(from: date)
        print(dateString)
        guard let url = URL(string: "https://festivaldujeuback.onrender.com/zoneBenevole/date/\(dateString)") else {
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
                    let zones = try decoder.decode([Zone].self, from: data)
                    self?.zones = zones
                } catch {
                    self?.errorMessage = "Échec de décodage : \(error.localizedDescription)"
                    print("echec de decodage")
                }
            }
        }
        task.resume()
    }
    
    func zonesDisponiblesPourHeure(date: Date, heure: String) -> [Zone] {
        return zones.filter { zone in
            zone.date == date &&
            zone.horaireCota.contains { cota in
                cota.heure == heure && (cota.nbBenevole ?? 0) != 0 && (cota.listeBenevole?.count ?? 0) < (cota.nbBenevole ?? 0)
            }
        }
    }
    
    func participerALaZone(idBenevole: String, idHoraire: String, completion: @escaping (Bool, String?) -> Void) {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        guard let url = URL(string: "https://festivaldujeuback.onrender.com/zoneBenevole/participer/\(idHoraire)/\(idBenevole)") else {
            completion(false, "URL invalide pour l'inscription.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Erreur lors de la participation : \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Réponse invalide du serveur.")
                return
            }

            if let data = data, httpResponse.statusCode != 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    let message = json?["message"] as? String ?? "Erreur lors de la participation."
                    
                    // Adapter le message en fonction de celui du backend
                    let finalMessage = message.contains("Le bénévole est déjà inscrit") ? "Vous êtes déjà inscrit quelque part à cette heure-ci." : message
                    completion(false, finalMessage)
                } catch {
                    completion(false, "Erreur lors du décodage de la réponse du serveur.")
                }
            } else if httpResponse.statusCode == 200 {
                completion(true, "Votre participation à la zone a été enregistrée avec succès.")
            } else {
                completion(false, "Erreur inconnue.")
            }
        }.resume()
    }
    
    func fetchJeuxByZone(idZone: String) {
        print("Zone : \(idZone)")
            guard let url = URL(string: "https://festivaldujeuback.onrender.com/zoneBenevole/\(idZone)/jeux") else {
                DispatchQueue.main.async {
                    self.errorMessage = "L'URL pour récupérer les jeux est invalide."
                }
                return
            }

            isLoading = true
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        self?.errorMessage = "Échec du chargement des jeux : \(error.localizedDescription)"
                        print("Échec du chargement des jeux : \(error.localizedDescription)")
                        return
                    }
                    guard let data = data else {
                        self?.errorMessage = "Aucune donnée reçue."
                        print("Aucune donnée reçue.")
                        return
                    }
                    
                    do {
                        let jeux = try JSONDecoder().decode([Jeu].self, from: data)
                        self?.jeux = jeux
                    } catch {
                        self?.errorMessage = "Échec de décodage des jeux : \(error.localizedDescription)"
                        print("Échec de décodage des jeux : \(error.localizedDescription)")
                    }
                }
            }.resume()
        }
    
//    func removeBenevoleFromZone(idBenevole: String, idHoraire: String, completion: @escaping (Bool, String?) -> Void) {
//        print("je suis dans removeBenevoleFromZone")
//        print("bénévole : \(idBenevole)")
//        print("horaire : \(idHoraire)")
//        guard let url = URL(string: "https://festivaldujeuback.onrender.com/zoneBenevole/removeBenevole/\(idHoraire)/\(idBenevole)") else {
//            completion(false, "URL invalide pour la désinscription.")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(false, "Erreur lors de la désinscription : \(error.localizedDescription)")
//                print("Erreur lors de la désinscription : \(error.localizedDescription)")
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(false, "Réponse invalide du serveur.")
//                print("Réponse invalide du serveur.")
//                return
//            }
//
//            if httpResponse.statusCode == 200 {
//                if let index = self.zones.firstIndex(where: { zone in
//                    zone.horaireCota.contains(where: { cota in
//                        cota.id == idHoraire
//                    })
//                }),
//                   let horaireIndex = self.zones[index].horaireCota.firstIndex(where: { cota in
//                    cota.id == idHoraire
//                   }),
//                   let benevoleIndex = self.zones[index].horaireCota[horaireIndex].listeBenevole?.firstIndex(where: { benevole in
//                    benevole.id == idBenevole
//                   }) {
//                    var horaireCotaCopy = self.zones[index].horaireCota
//                    var listeBenevoleCopy = horaireCotaCopy[horaireIndex].listeBenevole ?? []
//                    listeBenevoleCopy.remove(at: benevoleIndex)
//
//                    let horaireCota = HoraireCota(id: horaireCotaCopy[horaireIndex].id,
//                                                  heure: horaireCotaCopy[horaireIndex].heure,
//                                                  nbBenevole: horaireCotaCopy[horaireIndex].nbBenevole,
//                                                  listeBenevole: listeBenevoleCopy)
//
//                    horaireCotaCopy[horaireIndex] = horaireCota
//
//                    let zone = Zone(id: self.zones[index].id,
//                                    nomZone: self.zones[index].nomZone,
//                                    referents: self.zones[index].referents,
//                                    idZone: self.zones[index].idZone,
//                                    date: self.zones[index].date,
//                                    listeJeux: self.zones[index].listeJeux,
//                                    horaireCota: horaireCotaCopy)
//
//                    self.zones[index] = zone
//                }
//
//                completion(true, "Vous avez été désinscrit de la zone avec succès.")
//                print("Vous avez été désinscrit de la zone avec succès.")
//            } else {
//                completion(false, "Erreur lors de la désinscription.")
//                print("Erreur lors de la désinscription.")
//            }
//        }.resume()
//    }

}
