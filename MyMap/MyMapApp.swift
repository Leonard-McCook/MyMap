//
//  MyMapApp.swift
//  MyMap
//
//  Created by Leonard McCook-Carr on 3/15/24.
//

import SwiftUI
import SwiftData

@main
struct MyMapApp: App {
    var body: some Scene {
        WindowGroup {
            StartTab()
        }
        .modelContainer(for: Destination.self)
    }
}
