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
    
    let customColor = UIColor(red: 29/255, green: 36/255, blue: 75/255, alpha: 0.8)

    var body: some View {
        NavigationView {
            VStack {
                if let image = UIImage(named: "logo") {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 150)
                        .offset(y : -30)
                }
                
                Text("Où veux-tu t'inscrire ?")
                    .font(.largeTitle)
                    .padding(.bottom, 40)
                
                Button("Stands") {
                    self.isActiveStand = true
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 200)
                .background(Color(customColor))
                .cornerRadius(8)

                Button("Zones") {
                    self.isActiveZone = true
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 200)
                .background(Color(customColor))
                .cornerRadius(8)
                
                    
                
                
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
#Preview{
    ParticiperView()
}
