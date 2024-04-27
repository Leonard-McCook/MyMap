//
//  TripMapView.swift
//  MyMap
//
//  Created by Leonard McCook-Carr on 3/18/24.
//

import SwiftUI
import MapKit
import SwiftData

struct TripMapView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var visibleRegion: MKCoordinateRegion?
    @Environment(LocationManager.self) var locationManager
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Query private var listPlacemarks: [MTPlacemark]
    
    // Search
    @State private var searchText = ""
    @FocusState private var searchFieldFocus: Bool
    @Query(filter: #Predicate<MTPlacemark> {$0.destination == nil}) private var searchPlacemarks: [MTPlacemark]
    
    @State private var selectedPlacemark: MTPlacemark?
    
    // Route
    @State private var showRoute = false
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem
    @State private var travelInterval: TimeInterval
    @State private var transportType = MKDirectionsTransportType.automobile
    
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selectedPlacemark) {
            UserAnnotation()
            ForEach(listPlacemarks) { placemark in
                Group {
                    if placemark.destination != nil {
                        Marker(coordinate: placemark.coordinate) {
                            Label(placemark.name, systemImage: "star")
                        }
                        .tint(.yellow)
                    } else {
                        Marker(placemark.name, coordinate: placemark.coordinate)
                    }
                }.tag(placemark)
            }
        }
        .sheet(item: $selectedPlacemark) { selectedPlacemark in
            LocationDetailView(
                selectedPlacemark: selectedPlacemark,
                showRoute: $showRoute
            )
                .presentationDetents([.height(450)])
        }
        .onMapCameraChange{ context in
            visibleRegion = context.region
        }
        .onAppear {
            updateCameraPosition()
        }
        .mapControls{
            MapUserLocationButton()
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                VStack {
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
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
                        .onSubmit {
                            Task {
                                await MapManager.searchPlaces(
                                    modelContext,
                                    searchText: searchText,
                                    visibleRegion: visibleRegion
                                )
                                searchText = ""
                            }
                        }
                }
                .padding()
                VStack {
                    if !searchPlacemarks.isEmpty {
                        Button {
                            MapManager.removeSearchResults(modelContext)
                        } label: {
                            Image(systemName: "mappin.slash")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                }
                .padding()
                .buttonBorderShape(.circle)
            }
        }
    }
    
    func updateCameraPosition() {
        if let userLocation = locationManager.userLocation {
            let userRegion = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.15,
                    longitudeDelta: 0.15
                )
            )
            withAnimation {
                cameraPosition = .region(userRegion)
            }
        }
    }
    
    func fetchRoute() async {
        if let userLocation = locationManager.userLocation, let selectedPlacemark {
            let request = MKDirections.Request()
            let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)
            let routeSource = MKMapItem(placemark: sourcePlacemark)
            let destinatinPlacemark = MKPlacemark(coordinate: 
                selectedPlacemark.coordinate)
            routeDestination = MKMapItem(placemark: destinatinPlacemark)
            routeDestination?.name = selectedPlacemark.name
            request.source = routeSource
            request.destination?.name = selectedPlacemark.name
            request.transportType = transportType
            let directions = MKDirections(request: request)
            let result = try? await directions.calculate()
            route = result?routes.first
            travelInterval.routes.first
            travelInterval = route?.expectedTravelTime
        }
    }
}

#Preview {
    TripMapView()
        .environment(LocationManager())
        .modelContainer(Destination.preview)
}
