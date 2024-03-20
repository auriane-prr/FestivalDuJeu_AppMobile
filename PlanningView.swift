//
//  PlanningView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct PlanningView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @ObservedObject var planningModel = PlanningViewModel()
    @ObservedObject var benevoleModel = BenevoleViewModel()
    
    var body: some View {
        VStack {
            if planningModel.isLoading {
                ProgressView()
            } else if let errorMessage = planningModel.errorMessage {
                Text(errorMessage)
            } else {
                Text("Stands")
                List(planningModel.standsPlanning, id: \.id) { stand in
                    
                    Text(stand.nomStand)
                }
                Text("Zones")
                List(planningModel.zonesPlanning, id: \.id) { zone in
                    
                    Text(zone.nomZone)
                }
            }
        }
        .onAppear {
            benevoleModel.getBenevoleId(pseudo: authModel.username) { benevoleId in
                guard let benevoleId = benevoleId else {
                    print("Impossible de récupérer l'ID du bénévole.")
                    return
                }
                planningModel.fetchStandsForBenevole(benevoleId: benevoleId)
                planningModel.fetchZonesForBenevole(benevoleId: benevoleId)
            }
        }
    }
    
}
