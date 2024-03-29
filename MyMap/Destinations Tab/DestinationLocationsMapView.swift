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
        Map(position: $cameraPosition) {
            Marker("Moulin Rouge", coordinate: .moulinRouge)
            Marker(coordinate: .arcDeTriomphe) {
                Label("Arch de Triomphe", systemImage: "star.fill")
            }
            .tint(.yellow)
            Marker("Eiffel Tower", image: "eiffelTower", coordinate: .eiffelTower)
                .tint(.blue)
            Marker("Gare du Nord", monogram: Text("GN"), coordinate: .gareDuNord)
                .tint(.accent)
            
            Marker("Louvre", systemImage: "person.crop.artframe", coordinate: .louvre)
                .tint(.appBlue)
            
            Annotation("Notre Dame", coordinate: .notreDame) {
                Image(systemName: "star")
                    .imageScale(.large)
                    .foregroundStyle(.red)
                    .padding(10)
                    .background(.white)
                    .clipShape(.circle)
            }
            
            Annotation("Sacre Coeur", coordinate: .sacreCoeur, anchor: .center) {
                Image(.sacreCoeur)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            
            Annotation("Pantheon", coordinate: .pantheon) {
                Image(systemName: "mappin")
                    .imageScale(.large)
                    .foregroundColor(.red)
                    .padding(5)
                    .overlay {
                        Circle()
                            .strokeBorder(.red, lineWidth: 2)
                    }
            }
            MapCircle(
                center: CLLocationCoordinate2D(latitude: 48.856788, longitude: 2.351077),
                radius: 5000)
        }
        .foregroundStyle(.red.opacity(0.4))
        
            .onAppear {
                let paris = CLLocationCoordinate2D(latitude: 48.856788, longitude: 2.351077)
                let parisSpan = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
                let parisRegion = MKCoordinateRegion(center: paris, span: parisSpan)
                cameraPosition = .region(parisRegion)
            }
    }
}

#Preview {
    DestinationLocationsMapView()
}
