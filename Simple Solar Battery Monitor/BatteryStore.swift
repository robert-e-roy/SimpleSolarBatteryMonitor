//
//  BatteryStore.swift
//  Simple Solar Battery Monitor
//
//  Created by Robert Roy on 2/5/21.
//

import SwiftUI
import Combine

class BatteryStore: ObservableObject
{
    let name: String
    
    func name(for battery: BatteryDocument) -> String {
        if batteryNames[battery] == nil {
            batteryNames[battery] = "Untitled0"
        }
        return batteryNames[battery]!
    }
    
    func setName(_ name: String, for battery: BatteryDocument) {
        batteryNames[battery] = name
    }
    
    var batteries: [BatteryDocument] {
        batteryNames.keys.sorted { batteryNames[$0]! < batteryNames[$1]! }
    }
    
    func addBattery(named name: String = "Untitled1") {
        batteryNames[BatteryDocument()] = name
    }

    func removeBattery(_ document: BatteryDocument) {
        batteryNames[document] = nil
    }
    
    @Published private var batteryNames = [BatteryDocument:String]()
    
    private var autosave: AnyCancellable?
    
    init(named name: String = "Any Battery") {
        self.name = name
        let defaultsKey = "BatteyStore.\(name)"
        batteryNames = Dictionary(fromPropertyList: UserDefaults.standard.object(forKey: defaultsKey))
        autosave = $batteryNames.sink { names in
            UserDefaults.standard.set(names.asPropertyList, forKey: defaultsKey)
        }
    }
}

extension Dictionary where Key == BatteryDocument, Value == String {
    var asPropertyList: [String:String] {
        var uuidToName = [String:String]()
        for (key, value) in self {
            uuidToName[key.id.uuidString] = value
        }
        return uuidToName
    }
    
    init(fromPropertyList plist: Any?) {
        self.init()
        let uuidToName = plist as? [String:String] ?? [:]
        for uuid in uuidToName.keys {
            self[BatteryDocument(id: UUID(uuidString: uuid))] = uuidToName[uuid]
        }
    }
}
