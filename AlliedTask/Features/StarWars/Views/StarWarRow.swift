//
//  StarViewRow.swift
//  AlliedTask
//
//  Created by Adel Aref on 13/11/2021.
//

import Foundation
import SwiftUI
import Combine
struct StarWarRow: View {
    var starWar: StarWarModel
    let imageLoader = ImageLoader()

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let url = URL(string: starWar.image ?? "") {
                    AlliedImage(imageLoader: imageLoader, imageURL: url)
                        .frame(width: 70.0, height: 70.0, alignment: .leading)
                }
                Text(starWar.name ?? "").font(.subheadline)

            }.onAppear {
                withAnimation(.spring()) {
                }
            }
        }
    }
}
