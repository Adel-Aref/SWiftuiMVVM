//
//  AlliedImage.swift
//  AlliedTask
//
//  Created by Adel Aref on 13/11/2021.
//

import Foundation
import SwiftUI
struct AlliedImage: View {

    @ObservedObject var imageLoader: ImageLoader
    let imageURL: URL

    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.3))
            if let image = self.imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .onAppear {
            self.imageLoader.loadImage(with: self.imageURL)
        }
    }
}
