//
//  Simple_Solar_Battery_MonitorApp.swift
//  Simple Solar Battery Monitor
//
//  Created by Robert Roy on 1/24/21.
//

import SwiftUI

@main
struct Simple_Solar_Battery_MonitorApp: App {
    var body: some Scene {
        let store = BatteryStore(named: "Simple Battery Monitor")
        WindowGroup{
            BatteryChooserView().environmentObject(store)
        }
    }
}
