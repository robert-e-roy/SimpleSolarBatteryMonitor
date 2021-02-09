//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/27/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct BatteryDocumentView: View {
    @ObservedObject var battery: BatteryDocument
    
    @State private var editMode: EditMode = .inactive
    @State private var addLogValue: String = ""
    @State private var isEditing = false


    init(battery: BatteryDocument) {
        self.battery = battery
    }
    
    var body: some View {
        VStack {
            HStack {
                ScrollView(.vertical){
                    //
                    HStack{
                        Text ( "Name: \(battery.name)")
                        let maxvolts = String(format: "%.2f", battery.maxVolts)
                        Text ( " Voltage: \(maxvolts)")
                    }
                    ForEach (battery.logs ) { log in
                        let voltage = String(format: "%.2f", log.volts)
                        let date = LogDate(date: log.date)
                        let color = percent(current: log.volts ,max: battery.maxVolts)
                        
                        HStack {
                           // Text ( "Entry: \(log.id) ")
                            Text( "\(voltage)" )
                            Text( " On: \(date)" )
                           // Text( " Percent : \(percent)" )

                        }.background(color)
                    }
                    TextField("new measurement" , text: $addLogValue)
                            { isEditing in
                                self.isEditing = isEditing
                            } onCommit: {
                                if let new = Float( addLogValue) {
                                        battery.addVoltageLog(volts: new)
                                }
                                addLogValue = ""
                            }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        
        }
        .navigationBarItems(
            trailing: EditButton()
        )
        .environment(\.editMode, $editMode)

    }

    func addVoltageLog(volts: Float) {
        self.battery.addVoltageLog(volts:volts)
    }
}
func LogDate ( date:Date) -> String {
    let df = DateFormatter()

    df.setLocalizedDateFormatFromTemplate("MMMdd HH:mm")
    return df.string(from: date)
    }

func percent ( current: Float, max: Float) -> Color {
    
    let percent = (current - 12) / (max - 12) * 100
    if percent > 60 {
        return Color.green
    }
    else{
        return Color.red
    }
}
