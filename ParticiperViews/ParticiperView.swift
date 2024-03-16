//
//  ParticiperView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 16/03/2024.
//

import SwiftUI

struct ParticiperView: View {
    @EnvironmentObject private var logoutModel: AuthViewModel
    @State private var isActiveStand = false
    @State private var isActiveZone = false

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    self.isActiveStand = true
                }) {
                    Text("Stand")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    self.isActiveZone = true
                }) {
                    Text("Zones")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .navigationTitle("Où veux-tu t'inscrire ?")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        logoutButton
                    }
                }
                .sheet(isPresented: $isActiveStand) {
                    ParticiperStandView()
                }
                .sheet(isPresented: $isActiveZone) {
                    ParticiperZoneView()
                }
            }
        }
    }

    var logoutButton: some View {
        Button(action: {
            logoutModel.logout()
        }) {
            Text("Logout")
        }
    }
}
