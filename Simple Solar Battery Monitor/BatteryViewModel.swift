//
//  BatteryViewModel.swift
//  Simple Solar Battery Monitor
//
//  Created by Robert Roy on 1/25/21.
//

import SwiftUI
import Combine

class BatteryDocument: ObservableObject, Hashable, Identifiable
{
    @Published var battery: Battery {
        willSet {
            objectWillChange.send()
        }
        didSet {
            UserDefaults.standard.set(battery.json, forKey: battery.id.uuidString)
        }
    }

    static func == (lhs: BatteryDocument, rhs: BatteryDocument) -> Bool {
        lhs.id == rhs.id
    }
    let id: UUID
    var  maxVolts: Float {
        get {battery.MaxVoltage}
        set {battery.MaxVoltage = newValue}
    }
    
    var logs: [Battery.Logs] {
        get {
            battery.logs
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    private var autosaveCancellable: AnyCancellable?
    
    init(id: UUID? = nil) {
        self.id = id ?? UUID()
        let defaultsKey = "BatteryDocument.\(self.id.uuidString)"
        battery = Battery(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? Battery()
        autosaveCancellable = $battery.sink { battery in
            UserDefaults.standard.set(battery.json, forKey: defaultsKey)
        }
    }
    //Mark: -- Intents
    func addVoltageLog(volts: Float) {
        battery.addVoltageLog(volts: volts)
    }
    
    
    func removeVoltageLog( log: Battery.Logs) {
        battery.removeVoltageLog(log: log)
    }
}
