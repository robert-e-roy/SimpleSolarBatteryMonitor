//
//  BatterViewyChooser.swift
//  Simple Solar Battery Monitor
//
//  Created by Robert Roy on 1/24/21.
//

import SwiftUI

struct BatteryChooserView: View {
    @EnvironmentObject var store: BatteryStore
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {            List {
                ForEach(store.batteries) { battery in
                    NavigationLink(destination: BatteryDocumentView(battery: battery)
                        .navigationBarTitle(self.store.name(for: battery))
                    ) {
                        EditableText(self.store.name(for: battery), isEditing: self.editMode.isEditing) { name in
                            self.store.setName(name, for: battery)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { self.store.batteries[$0] }.forEach { document in
                        self.store.removeBattery(document)
                    }
                }
            }
            .navigationBarTitle(self.store.name)
            .navigationBarItems(
                leading: Button(action: {
                    self.store.addBattery()
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                }),
                trailing: EditButton()
            )
            .environment(\.editMode, $editMode)
        }
    }
        
}

