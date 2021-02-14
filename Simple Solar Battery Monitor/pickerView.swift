//
//  pickerView.swift
//  picker
//
//  Created by Robert Roy on 2/14/21.
//

import SwiftUI

struct pickerView: View {
    var nominalVoltage: [String]
    
    @Binding  var share: Int

    var body: some View {
        Picker(selection: $share, label: Text("")) {
            ForEach(0 ..< nominalVoltage.count) {
                Text(self.nominalVoltage[$0])
            }
        }
    }
}

