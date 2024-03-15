//
//  RegisterViewModel.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var benevole = Benevole(admin: false, referent: false, nom: "", prenom: "", pseudo: "", password: "", association: "", taille_tshirt: "", vegetarien: false, mail: "", hebergement: "", adresse: "", num_telephone: "")
    
    @Published var errorMessage: String = ""
    @Published var successMessage: String? = ""
    @Published var isGeneratingPseudo = false

    func register() async {
        
        guard let url = URL(string: "https://festivaldujeuback.onrender.com/benevole/signup") else {
            DispatchQueue.main.async {
                self.errorMessage = "URL incorrecte."
            }
            return
        }
        
        guard let finalBody = try? JSONEncoder().encode(benevole) else {
            DispatchQueue.main.async {
                self.errorMessage = "Erreur de formatage des données."
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                DispatchQueue.main.async {
                    self.errorMessage = "Échec de l'inscription. Veuillez réessayer."
                    print("echec")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.successMessage = "Inscription réussie. Veuillez vous connecter."
                print("inscription réussie")
                // Vous pouvez choisir de réinitialiser les champs ici
                self.benevole = Benevole(admin: false, referent: false, nom: "", prenom: "", pseudo: "", password: "", association: "", taille_tshirt: "", vegetarien: false, mail: "", hebergement: "", adresse: "", num_telephone: "")
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Erreur lors de l'inscription: \(error.localizedDescription)"
                print("erreur")
            }
        }
    }
    
    func isFormValid() -> Bool {
        return !benevole.nom.isEmpty && !benevole.prenom.isEmpty &&
            !benevole.password.isEmpty && !benevole.pseudo.isEmpty &&
            !benevole.mail.isEmpty && !benevole.association.isEmpty &&
            !benevole.hebergement.isEmpty
    }
    
    func checkPseudoUnique(pseudo: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://festivaldujeuback.onrender.com/benevole/check-pseudo/\(pseudo)") else {
            print("URL invalide")
            completion(true) // Présumez non unique pour éviter des problèmes
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Erreur lors de la vérification du pseudo:", error?.localizedDescription ?? "Inconnue")
                completion(true) // Présumez non unique pour éviter des problèmes
                return
            }

            if let response = try? JSONDecoder().decode([String: Bool].self, from: data), let exists = response["exists"] {
                completion(exists)
            } else {
                print("Réponse invalide du serveur lors de la vérification du pseudo")
                completion(true) // Présumez non unique pour éviter des problèmes
            }
        }.resume()
    }
    
    func generatePseudoIfNeeded() {
        guard !benevole.nom.isEmpty, !benevole.prenom.isEmpty else {
            return
        }

        isGeneratingPseudo = true
        let basePseudo = "\(benevole.prenom)\(String(benevole.nom.prefix(1)))"
        var counter = 1

        // Fonction récursive pour vérifier l'unicité du pseudo
        func checkAndAssignUniquePseudo(_ pseudo: String) {
            checkPseudoUnique(pseudo: pseudo) { exists in
                DispatchQueue.main.async {
                    if exists {
                        let newPseudo = "\(basePseudo)\(counter)"
                        counter += 1
                        print("Pseudo \(newPseudo) already exists, incrementing counter.")
                        checkAndAssignUniquePseudo(newPseudo)
                    } else {
                        self.benevole.pseudo = pseudo
                        self.isGeneratingPseudo = false
                    }
                }
            }
        }

        checkAndAssignUniquePseudo(basePseudo)
    }

}
