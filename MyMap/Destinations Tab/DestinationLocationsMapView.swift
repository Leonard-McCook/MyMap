//
//  DestinationLocationsMapView.swift
//  MyMap
//
//  Created by Leonard McCook-Carr on 3/17/24.
//

import SwiftUI
import MapKit
import SwiftData

struct DestinationLocationsMapView: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var searchText = ""
    @FocusState private var searchFieldFocus: Bool
    var destination: Destination
    var body: some View {
        @Bindable var destination = destination
        VStack {
            LabeledContent {
                TextField("Enter destination name", text: $destination.name)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.primary)
            } label: {
                Text("Name")
            }
            HStack {
                Text("Adjust the map to set the region for your destination.")
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Set region") {
                    if let visibleRegion {
                        destination.latitude = visibleRegion.center.latitude
                        destination.longitude = visibleRegion.center.longitude
                        destination.latitudeDelta = visibleRegion.span.latitudeDelta
                        destination.longitudeDelta = visibleRegion.span.longitudeDelta
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.horizontal)
        Map(position: $cameraPosition) {
            ForEach(destination.placemarks) { placemark in
                Marker(coordinate: placemark.coordinate) {
                    Label(placemark.name, systemImage: "star")
                }
                .tint(.yellow)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                TextField("Search...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .focused($searchFieldFocus)
                    .overlay(alignment: .trailing) {
                        if searchFieldFocus {
                            Button {
                                searchText = ""
                                searchFieldFocus = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                            .offset(x: -5)
                        }
                    }
            }
            .padding()
        }
        .navigationTitle("Destination")
        .navigationBarTitleDisplayMode(.inline)
        .onMapCameraChange(frequency: .onEnd){ context in
            visibleRegion = context.region
        }
        .onAppear {
            if let region = destination.region {
                cameraPosition = .region(region)
            }
        }
    }
}

#Preview {
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<Destination>()
    let destination = try! container.mainContext.fetch(fetchDescriptor)[0]
    return NavigationStack {
        DestinationLocationsMapView(destination: destination)
    }
}
