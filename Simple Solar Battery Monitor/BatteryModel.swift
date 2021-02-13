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
    
    var MaxVoltage: Float    // make this cell number with a picker

    var logs: [Logs]
    let id: UUID
    
    fileprivate init( MaxVoltage: Float, logs: [Logs], id: UUID ) {
        self.MaxVoltage = MaxVoltage
        self.logs = logs
        self.id = id
    }
    
    struct Logs: Codable, Identifiable, Hashable {
        var date: Date
        var volts: Float
        var id: Int
        
        fileprivate init( volts: Float, id: Int) {
            self.date = Date()
            self.volts = volts
            self.id = id
        }
    }

    init() {
        self.init(MaxVoltage: 13.0,logs: [Battery.Logs](),id: UUID() )
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
  
    private var uniqueLogId = 0
    
    mutating func addVoltageLog(volts: Float){
        logs.append(Logs( volts: volts, id: uniqueLogId))
        uniqueLogId += 1
    }
    mutating func removeVoltageLog(log: Battery.Logs){
        if let chosenIndex = logs.firstIndex(of: log) {
            logs.remove(at: chosenIndex)
        }
    }
    mutating func changeMax(volts: Float){
        self.MaxVoltage = volts
    }
    
}
