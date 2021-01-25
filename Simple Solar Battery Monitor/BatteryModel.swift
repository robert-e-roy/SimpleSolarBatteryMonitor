//
//  BatteryModel.swift
//  Simple Solar Battery Monitor
//
//  Created by Robert Roy on 1/25/21.
//

import Foundation

struct SetOfBatteries: Codable {

    var batteries = [Battery]()
    
    struct Logs: Codable {
       let date: Date
       let voltage: Float
   }
     
    struct Battery: Codable, Identifiable {
        let name: String
        let MaxVoltage: Float
        var logs: [Logs]
        let id: Int
        
        
        
        fileprivate init( name: String, MaxVoltage: Float, logs: [Logs], id: Int ) {
            self.name = name
            self.MaxVoltage = MaxVoltage
            self.logs = logs
            self.id = id
        }
    }
    
private var uniqueID = 0
    
var json: Data? {
    return try? JSONEncoder().encode(self)
}
init () {}
    
    mutating func addBattery( name: String , MaxVoltage: Float , logs: [Logs], id: Int ) {
        uniqueID += 1
        batteries.append( Battery(name: name, MaxVoltage: MaxVoltage, logs: logs, id: id ) )
        
    }

}
