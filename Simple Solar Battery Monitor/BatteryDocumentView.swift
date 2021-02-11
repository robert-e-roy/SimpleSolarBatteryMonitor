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
        Group {
            HStack{
                let maxvolts = String(format: "%.2f", battery.maxVolts)
                Text ( "Max Voltage: \(maxvolts)")
            }
            
            ScrollView(.vertical){
                
                ForEach (battery.logs ) { log in
                    let voltage = String(format: "%.2f", log.volts)
                    let date = LogDate(date: log.date)
                    let (color,percent) = percent(current: log.volts ,max: battery.maxVolts)
                    let percentString = String(format: "%.0f", percent)
                    HStack {
                        Text( "\(voltage)" )
                        Text( " On: \(date)" )
                        Text( " \(percentString) %" )
                    }.background(color)
                    .onLongPressGesture {
                        if self.editMode.isEditing {
                            battery.removeVoltageLog(log: log)
                        }
                    }
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
                //.keyboardType(.decimalPad) no done button
            }
        }
        .font(.body)
        .navigationBarItems(
            trailing: EditButton()
        )
        .environment(\.editMode, $editMode)
        
    }
}

func LogDate ( date:Date) -> String {
    let df = DateFormatter()
    df.setLocalizedDateFormatFromTemplate("MMMdd HH:mm")
    return df.string(from: date)
    }
enum cellVoltage: Float {
    case hundred = 12.6
    case ninty = 12.5
    case eighty = 12.42
    case seventy = 12.32
    case sixty = 12.20
    case fifty = 12.06
    case foury = 11.90
    case thrity = 11.75
    case twenty = 11.58
    case ten = 11.31
}
func percent ( current: Float, max: Float) -> (Color,Float) {
    
    if current >= cellVoltage.hundred.rawValue {
        return (Color.green,100)
    } else if ( current >= cellVoltage.ninty.rawValue ) {
        return (Color.green,90)
    } else if ( current >= cellVoltage.eighty.rawValue ) {
        return (Color.green,80)
    } else if ( current >= cellVoltage.seventy.rawValue ) {
        return (Color.green,70)
    } else if ( current >= cellVoltage.sixty.rawValue ) {
        return (Color.green,60)
    } else if ( current >= cellVoltage.fifty.rawValue ) {
        return (Color.green,50)
    } else if ( current >= cellVoltage.foury.rawValue ) {
        return (Color.green,40)
    } else if ( current >= cellVoltage.thrity.rawValue ) {
        return (Color.yellow,30)
    } else if ( current >= cellVoltage.twenty.rawValue ) {
        return (Color.yellow,20)
    } else if ( current >= cellVoltage.ten.rawValue ) {
        return (Color.red,10)
    } else {
        return (Color.red,0)
    }
}
