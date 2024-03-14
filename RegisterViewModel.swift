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
}
