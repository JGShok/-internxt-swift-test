//
//  PhotoGallery.swift
//  gallery
//
//  Created by Femer Garcia on 18/10/23.
//

import SwiftUI
import os.log

struct PhotoGalleryView: View {
    @ObservedObject var photoCollection : PhotoCollection
    
    @Environment(\.displayScale) private var displayScale
    
    private static let itemSpacing = 1.0
    private static let itemCornerRadius = 1.0
    private static let itemSize = CGSize(width: 75, height: 75)
    
    private var imageSize: CGSize {
        return CGSize(width: Self.itemSize.width * min(displayScale, 2), height: Self.itemSize.height * min(displayScale, 2))
    }
    
    private let columns = [
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height), spacing: itemSpacing),
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height), spacing: itemSpacing),
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height), spacing: itemSpacing),
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height), spacing: itemSpacing),
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height), spacing: itemSpacing),
    ]
    
    var body: some View {
        NavigationView {
            if photoCollection.photoAssets.isEmpty {
                Label {
                    Text("No Photos or Videos")
                } icon: {
                    Image(systemName: "photo.on.rectangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60.0, height: 60.0)
                        .foregroundColor(Color.gray)
                }
                .labelStyle(VerticalLabelStyle())
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: Self.itemSpacing) {
                        ForEach(photoCollection.photoAssets) { asset in
                            photoItemView(asset: asset)
                        }
                    }
                    .padding([.vertical], Self.itemSpacing)
                }
                .navigationTitle("Photos")
            }
        }
    }
    
    private func photoItemView(asset: PhotoAsset) -> some View {
        PhotoItemView(asset: asset, cache: photoCollection.cache, imageSize: imageSize)
            .frame(width: Self.itemSize.width, height: Self.itemSize.height)
            .clipped()
            .cornerRadius(Self.itemCornerRadius)
            .overlay(alignment: .bottomLeading) {
                if asset.mediaType == .video {
                    Image(systemName: "video")
                        .foregroundColor(.white)
                        .font(.caption2)
                        .offset(x: 4, y: -4)
                }
            }
            .onAppear {
                Task {
                    await photoCollection.cache.startCaching(for: [asset], targetSize: imageSize)
                }
            }
            .onDisappear {
                Task {
                    await photoCollection.cache.stopCaching(for: [asset], targetSize: imageSize)
                }
            }
    }
}

struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .center, spacing: 8) {
            configuration.icon
            configuration.title
        }
    }
}

struct PhotoGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGalleryView(photoCollection: PhotoCollection(smartAlbum: .smartAlbumUserLibrary))
    }
}
