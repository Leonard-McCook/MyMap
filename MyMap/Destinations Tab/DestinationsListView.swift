//
//  DestinationsListView.swift
//  MyMap
//
//  Created by Leonard McCook-Carr on 4/2/24.
//

import SwiftUI
import SwiftData

struct DestinationsListView: View {
    @Query(sort: \Destination.name) private var destinations: [Destination]
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DestinationsListView()
}
