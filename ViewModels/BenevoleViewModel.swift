//
//  BenevoleViewModel.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 16/03/2024.
//

import Foundation

class BenevoleViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var benevole: Benevole?
    @Published var isLoading = false
    
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
    
    func fetchBenevole(pseudo: String) {
        print("fetchBenevole : \(pseudo)")
        guard let url = URL(string: "https://festivaldujeuback.onrender.com/benevole/pseudo/\(pseudo)") else {
            self.errorMessage = "URL invalide."
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
                guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    self?.errorMessage = "Réponse invalide du serveur."
                    print("réponse invalide du serveur")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(BenevoleResponse.self, from: data)
                    self?.benevole = response.benevole
                } catch {
                    self?.errorMessage = "Échec de décodage : \(error.localizedDescription)"
                    print("echec de decodage")
                }
            }
        }
        task.resume()
    }

    
}
