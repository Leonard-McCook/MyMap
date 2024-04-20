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
    @State private var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                StartTab()
            } else {
//                LocationDeniedView()
            }
        }
        .modelContainer(for: Destination.self)
        .environment(locationManager)
    }
}
