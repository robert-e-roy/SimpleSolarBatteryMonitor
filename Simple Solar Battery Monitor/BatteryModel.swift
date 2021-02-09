//
//  BatteryModel.swift
//  Simple Solar Battery Monitor
//
//  Created by Robert Roy on 1/25/21.
//

import Foundation



struct Battery: Codable, Identifiable, Hashable {

    static func == (lhs: Battery, rhs: Battery) -> Bool {
        lhs.id == rhs.id
    }
    
    var name: String
    let MaxVoltage: Float
    var logs: [Logs]
    let id: UUID
    
    fileprivate init( name: String, MaxVoltage: Float, logs: [Logs], id: UUID ) {
        self.name = name
        self.MaxVoltage = MaxVoltage
        self.logs = logs
        self.id = id
    }
    
    struct Logs: Codable, Identifiable, Hashable {
        var date: Date
        var volts: Float
        var id: UUID
        
        fileprivate init( volts: Float) {
            self.date = Date()
            self.volts = volts
            self.id = UUID()
        }
        
    }
    init() {
        
        self.init(name: "name",MaxVoltage: 13.0,logs: [Battery.Logs](),id: UUID())
    }
    
    private var uniqueLogID = 0
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data?) {
        if json != nil, let newBattery = try? JSONDecoder().decode(Battery.self, from: json!) {
            self = newBattery
        } else {
            return nil
        }
    }
    mutating func addVoltageLog(volts: Float){        
        logs.append(Logs( volts: volts))
    }
    
    
}





