//
//  MacExtensionToolApp.swift
//  MacExtensionTool
//
//  Created by sharui on 2021/3/18.
//

import SwiftUI

@main
struct MacExtensionToolApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
