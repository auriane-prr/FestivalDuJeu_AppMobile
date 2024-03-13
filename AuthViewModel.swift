//
//  AuthViewModel.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var benevole: Benevole?
    @Published var errorMessage: String = ""
    @Published var isAuthenticated = false
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var loginViewPresented: Bool = false
    
    // Suppose que le token d'authentification contient toutes les infos de l'utilisateur
    func login(username: String, password: String) async {
        guard let url = URL(string: "https://festivaldujeuback.onrender.com/benevole/login") else {
            DispatchQueue.main.async {
                self.errorMessage = "URL incorrecte"
            }
            return
        }
        
        let body: [String: Any] = ["pseudo": username, "password": password]
        guard let finalBody = try? JSONSerialization.data(withJSONObject: body) else {
            DispatchQueue.main.async {
                self.errorMessage = "Erreur de formatage des données"
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Pas de réponse HTTP")
                return
            }
            
            print("Statut HTTP : \(httpResponse.statusCode)")
            
            switch httpResponse.statusCode {
            case 200:
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                DispatchQueue.main.async {
                    print("Connexion réussie")
                    UserDefaults.standard.set(loginResponse.token, forKey: "authToken")
                    self.isAuthenticated = true
                    self.username = username
                    print("Pseudo du bénévole connecté: \(username)")
                }
            case 404:
                DispatchQueue.main.async {
                    self.errorMessage = "Utilisateur non trouvé"
                    print("Utilisateur non trouvé")
                }
            case 401:
                DispatchQueue.main.async {
                    self.errorMessage = "Mot de passe incorrect"
                    print("Mot de passe incorrect")
                }
            default:
                DispatchQueue.main.async {
                    self.errorMessage = "Échec de la connexion"
                    print("Échec de la connexion avec code de statut: \(httpResponse.statusCode)")
                }
            }
        } catch {
            print("Erreur lors de la connexion: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = "Erreur lors de l'authentification: \(error.localizedDescription)"
            }
        }
    }
    
    func logout() {
            // Déconnexion de l'utilisateur
            // Réinitialisation des données utilisateur
            self.benevole = nil
            self.isAuthenticated = false
            self.username = ""
            self.password = ""

            // Suppression du token d'authentification
            UserDefaults.standard.removeObject(forKey: "authToken")
        print("déconnexion")
        print("Pseudo du bénévole connecté: \(username)")
        }
    
    struct LoginResponse: Decodable {
        let token: String
    }

//    struct UserDetails {
//        // Définir les champs requis pour register
//    }
    
}
