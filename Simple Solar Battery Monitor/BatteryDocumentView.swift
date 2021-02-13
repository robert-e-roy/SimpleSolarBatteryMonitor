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
    @State private var newMaxValue: String = ""

    @State private var isEditing = false
    
    init(battery: BatteryDocument) {
        self.battery = battery
    }
    
    var body: some View {
        Group {
            HStack {
                let myvolts = String(format: "%.2f", battery.maxVolts)
                //  Text ( "Max Voltage: \(maxvolts)")
                if editMode == .active {
                    Text( "Enter new Value for max")
                    TextField("new Max" , text: $newMaxValue)
                    { isEditing in
                        self.isEditing = isEditing
                    } onCommit: {
                        if let new = Float( newMaxValue ) {
                            battery.maxVolts = new
                        }
                        newMaxValue = ""
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            } else {
                Text ( "Max Voltage: \(myvolts)")
                
            }
        }
        
            ScrollView(.vertical){
                ForEach (battery.logs ) { log in
                    let voltage = String(format: "%.2f", log.volts)
                    let date = LogDate(date: log.date)
                    let (color,percent) = percent(measuremnt: log.volts ,max: battery.maxVolts)
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
enum cellVoltage: Float { // 6 cell lead acid battery
    case hundred = 2.1
    case ninty   = 2.08
    case eighty  = 2.07
    case seventy = 2.05
    case sixty   = 2.03
    case fifty   = 2.01
    case foury   = 1.98
    case thrity  = 1.95
    case twenty  = 1.93
    case ten     = 1.885
}
func percent ( measuremnt : Float, max: Float) -> (Color,Float) {
    let cells = max / 2.1
    let current =  measuremnt / cells.rounded(.towardZero)
 //   print ("current = \(current) cells \(cells.rounded(.towardZero))")
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

