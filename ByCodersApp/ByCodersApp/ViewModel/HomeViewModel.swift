//
//  HomeViewModel.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 01/12/22.
//

import Foundation

protocol HomeViewModelProtocol {
    func saveUserLocation(latitude: Double?, longitude: Double?)
}

class HomeViewModel: HomeViewModelProtocol {
    weak var coordinator: RootCoordinator?
    private var sqliteService: SQLiteServiceProtocol?
    
    init(service: SQLiteServiceProtocol) {
        self.sqliteService = service
    }
    
    func saveUserLocation(latitude: Double?, longitude: Double?) {
        guard let sqliteService = sqliteService else {
            return
        }

        sqliteService.dropTables()
        sqliteService.initTables()
        guard let lat = latitude,
              let long = longitude,
              let uid = UserDefaults.standard.string(forKey: "uid") else { return }
        let userLocation = UserLocation(uid: uid, latitude: String(lat), longitude: String(long))
        _ = sqliteService.createUserLocation(userLocation: userLocation)
    }

}
