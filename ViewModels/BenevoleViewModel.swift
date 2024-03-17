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
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

        guard let urlFetchId = URL(string: "https://festivaldujeuback.onrender.com/benevole/pseudo/\(pseudo)") else {
            print("URL invalide pour récupérer l'ID.")
            DispatchQueue.main.async {
                self.errorMessage = "URL invalide pour récupérer l'ID."
            }
            return
        }

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

            if httpResponse.statusCode != 200 {
                print("Réponse invalide du serveur : Statut \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    self?.errorMessage = "Réponse invalide du serveur : Statut \(httpResponse.statusCode)"
                }
                return
            }

            do {
                let response = try JSONDecoder().decode(BenevoleResponse.self, from: data)
                let benevoleId = response.benevole._id
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

    func modifyBenevole(benevole: Benevole, update: BenevoleUpdate) {
        print("pseudo du benevole à modifier : \(benevole.pseudo)")

        guard let url = URL(string: "https://festivaldujeuback.onrender.com/benevole/\(benevole.pseudo)") else {
            print("URL invalide.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let updateData = [
                "nom": update.nom ?? benevole.nom,
                "prenom": update.prenom ?? benevole.prenom,
                "pseudo": benevole.pseudo, // Le pseudo est nécessaire pour l'URL, mais ne doit pas être modifié
                "association": update.association ?? benevole.association,
                "taille_tshirt": update.taille_tshirt ?? benevole.taille_tshirt,
                "vegetarien": update.vegetarien ?? benevole.vegetarien,
                "mail": update.mail ?? benevole.mail,
                "hebergement": update.hebergement ?? benevole.hebergement,
                "num_telephone": update.num_telephone ?? benevole.num_telephone,
                "adresse": update.adresse ?? benevole.adresse
            ].compactMapValues { $0 }

        do {
                let jsonData = try JSONSerialization.data(withJSONObject: updateData)
                request.httpBody = jsonData
                print(String(data: jsonData, encoding: .utf8) ?? "Invalid JSON data") // Imprime les données JSON envoyées
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Erreur lors de la sérialisation des données: \(error.localizedDescription)"
                    print("Erreur lors de la sérialisation des données: \(error)")
                }
                return
            }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Erreur réseau: \(error.localizedDescription)"
                    print("Erreur réseau: \(error)")
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)") // Imprime le code de statut HTTP

                // Essaye d'imprimer la réponse du serveur
                if let responseData = data, let responseString = String(data: responseData, encoding: .utf8) {
                    print("Response: \(responseString)")
                }

                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Réponse invalide du serveur."
                        print("Réponse invalide du serveur.")
                    }
                    return
                }
            }

            DispatchQueue.main.async {
                self.successMessage = "Profil mis à jour avec succès."
                print("Modifications enregistrées avec succès.")
            }
        }.resume()
    }

}
