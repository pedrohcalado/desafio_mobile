//
//  SQLiteService.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 30/11/22.
//

import Foundation
import SQLite

class SQLiteService {
    
    let id = Expression<Int64>("id")
    let uid = Expression<String>("uid")
    let latitude = Expression<String>("latitude")
    let longitude = Expression<String>("longitude")
    
    func createUserLocation(userLocation: UserLocation) -> Int64 {
        
        do {
            let db = try Connection(fileName())
            let usersLocation = Table("usersLocation");
//            try db.run(usersLocation.insert())
            
            let rowId = try db.run(usersLocation.insert(
                uid <- userLocation.uid,
                latitude <- userLocation.latitude,
                longitude <- userLocation.longitude))
            
            return rowId
            
        } catch {
            print("ERROR: \(error)")
        }
        return -1
    }
    
    func fileName() -> String {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        let name = "\(path)/db.sqlite3";
        return name;
    }
    
    func initTables() {
        do {
            let db = try Connection(fileName())
            
            try initUsersLocationTable(db: db)
            
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    func dropTables() {
        do {
            let db = try Connection(fileName())
            
            let contacts = Table("usersLocation");
            try db.run(contacts.drop(ifExists: true));
            
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    private func initUsersLocationTable(db: Connection) throws {
        let userLocation = Table("usersLocation");
        let id = Expression<Int64>("id")
        let uid = Expression<String>("uid")
        let latitude = Expression<String>("latitude")
        let longitude = Expression<String>("longitude")
        
        try db.run(userLocation.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(uid)
            t.column(latitude)
            t.column(longitude)
        })
    }
    
}

struct UserLocation {
    let uid: String
    let latitude: String
    let longitude: String
}
