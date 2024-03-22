//
//  JeuxViewModel.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 22/03/2024.
//

import Foundation
import Combine

class JeuViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var gameSuggestions: [ZoneJeu] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchTerm
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty && $0.count > 1 }
            .sink { [weak self] searchTerm in
                self?.fetchGameSuggestions(searchTerm: searchTerm)
            }
            .store(in: &cancellables)
    }

    func fetchGameSuggestions(searchTerm: String) {
        guard !searchTerm.isEmpty, searchTerm.count > 1,
              let searchURL = URL(string: "https://festivaldujeuback.onrender.com/jeux/search?search=\(searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            DispatchQueue.main.async {
                self.gameSuggestions = []
            }
            return
        }

        URLSession.shared.dataTask(with: searchURL) { [weak self] data, response, error in
            guard let data = data, error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    self?.gameSuggestions = []
                }
                return
            }

            do {
                let jeuxNoms = try JSONDecoder().decode([String].self, from: data)
                let group = DispatchGroup()
                var gamesWithZones: [ZoneJeu] = []
                
                jeuxNoms.forEach { nomJeu in
                    group.enter()
                    let zoneURLString = "https://festivaldujeuback.onrender.com/jeux/nom/\(nomJeu.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                    guard let zoneURL = URL(string: zoneURLString) else {
                        group.leave()
                        return
                    }

                    URLSession.shared.dataTask(with: zoneURL) { zoneData, zoneResponse, zoneError in
                        guard let zoneData = zoneData, zoneError == nil, let zoneResponse = zoneResponse as? HTTPURLResponse, zoneResponse.statusCode == 200 else {
                            group.leave()
                            return
                        }
                        
                        do {
                            let zoneResponse = try JSONDecoder().decode([String: String].self, from: zoneData)
                            if let nomZone = zoneResponse["nom_zone"] {
                                let gameWithZone = ZoneJeu(nomJeu: nomJeu, nomZone: nomZone)
                                gamesWithZones.append(gameWithZone)
                            }
                        } catch {
                            print("Erreur lors du décodage des données de la zone")
                        }
                        group.leave()
                    }.resume()
                }
                
                group.notify(queue: .main) {
                    self?.gameSuggestions = gamesWithZones
                }
            } catch {
                DispatchQueue.main.async {
                    self?.gameSuggestions = []
                }
            }
        }.resume()
    }
}

