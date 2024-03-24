//
//  FlexibleView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct FlexibleView: View {
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
                        .offset(y : -50)
                        .padding(.bottom, -20)
                }
                Text("Où veux-tu être flexible ?")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                Button("Stands") {
                    self.isActiveStand = true
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 180)
                .background(Color(customColor))
                .cornerRadius(8)

                Button("Zones") {
                    self.isActiveZone = true
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 180)
                .background(Color(customColor))
                .cornerRadius(8)
               
                .sheet(isPresented: $isActiveStand) {
                    FlexibleStandView()
                }
                .sheet(isPresented: $isActiveZone) {
                    FlexibleZoneView()
                }
            }
        }
    }
}

#Preview{
    FlexibleView()
}
