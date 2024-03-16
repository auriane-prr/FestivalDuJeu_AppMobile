//
//  ZoneViewModel.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 16/03/2024.
//

import Foundation


class ZoneViewModel: ObservableObject {

    @Published var zones: [Zone] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

}
