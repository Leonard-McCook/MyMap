//
//  DestinationLocationsMapView.swift
//  MyMap
//
//  Created by Leonard McCook-Carr on 3/17/24.
//

import SwiftUI
import MapKit

struct DestinationLocationsMapView: View {
    @State private var cameraPosition: MapCameraPosition =  .automatic
    
    var body: some View {
        Map(position: $cameraPosition)
            .onAppear {
                // 35.689506, 139.691700
                
                let tokyo = CLLocationCoordinate2D(latitude: 35.689506, longitude: 139.691700)
                let tokyoSpan = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
                let tokyoRegion = MKCoordinateRegion(center: tokyo, span: tokyoSpan)
                cameraPosition = .region(tokyoRegion)
            }
    }
}

#Preview {
    DestinationLocationsMapView()
}
