//
//  FlexibleViewModel.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 26/03/2024.
//

import Foundation

class FlexibleViewModel: ObservableObject {
    
    func ajouterFlexibleAuStand(benevoleId: String, horaires: [FlexibleStand], completion: @escaping (Bool, String?) -> Void) {
        print("flexible stand")
        guard let url = URL(string: "https://festivaldujeuback.onrender.com/flexible/") else {
            DispatchQueue.main.async {
                completion(false, "URL invalide pour ajouter un bénévole flexible.")
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "benevole_id": benevoleId,
            "horaire": horaires.map { horaire in
                [
                    "date": horaire.date,
                    "heure": horaire.heure,
                    "liste_stand": horaire.listeStand
                ]
            }
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch let error {
            DispatchQueue.main.async {
                completion(false, "Erreur lors de la création du corps de la requête : \(error.localizedDescription)")
                print("Erreur lors de la création du corps de la requête : \(error.localizedDescription)")
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, "Erreur réseau : \(error.localizedDescription)")
                    print("Erreur réseau : \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(false, "Réponse invalide du serveur.")
                    print("Réponse invalide du serveur.")
                }
                return
            }
            
            if httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(true, "Bénévole ajouté avec succès.")
                    print("Bénévole ajouté avec succès.")
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, "Erreur du serveur : Code de statut \(httpResponse.statusCode)")
                    print("Erreur du serveur : Code de statut \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    func ajouterFlexibleALaZone(benevoleId: String, horaires: [FlexibleZone], completion: @escaping (Bool, String?) -> Void) {
        print("flexible zone")
        guard let url = URL(string: "https://festivaldujeuback.onrender.com/flexibleZone/") else {
            DispatchQueue.main.async {
                completion(false, "URL invalide pour ajouter un bénévole flexible.")
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "benevole_id": benevoleId,
            "horaire": horaires.map { horaire in
                [
                    "date": horaire.date,
                    "heure": horaire.heure,
                    "liste_zoneBenevole": horaire.listeZone
                ]
            }
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch let error {
            DispatchQueue.main.async {
                completion(false, "Erreur lors de la création du corps de la requête : \(error.localizedDescription)")
                print("Erreur lors de la création du corps de la requête : \(error.localizedDescription)")
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, "Erreur réseau : \(error.localizedDescription)")
                    print("Erreur réseau : \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(false, "Réponse invalide du serveur.")
                    print("Réponse invalide du serveur.")
                }
                return
            }
            
            if httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(true, "Bénévole ajouté avec succès.")
                    print("Bénévole ajouté avec succès.")
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, "Erreur du serveur : Code de statut \(httpResponse.statusCode)")
                    print("Erreur du serveur : Code de statut \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}
