//
//  ContentView.swift
//  gallery
//
//  Created by Femer Garcia on 18/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = DataModel()
    
    var body: some View {
        PhotoGalleryView(photoCollection: model.photoCollection)
            .task {
                await model.loadPhotos()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
