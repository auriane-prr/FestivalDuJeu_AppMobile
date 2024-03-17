//
//  ParticiperView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 16/03/2024.
//

import SwiftUI

struct ParticiperView: View {
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
                .sheet(isPresented: $isActiveStand) {
                    ParticiperStandView()
                }
                .sheet(isPresented: $isActiveZone) {
                    ParticiperZoneView()
                }
            }
        }
    }

}
