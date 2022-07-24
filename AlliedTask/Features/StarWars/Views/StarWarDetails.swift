//
//  StarWarDetails.swift
//  AlliedTask
//
//  Created by Adel Aref on 13/11/2021.
//

import Foundation
import SwiftUI

struct StarWarDetails: View {
    var starWar: StarWarModel
    let imageLoader = ImageLoader()

    var body: some View {
        List {
            if let url = URL(string: starWar.image ?? "") {
                AlliedImage(imageLoader: imageLoader, imageURL: url)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            HStack {
                Text("Birth Year: ")
                Text(starWar.birth_year ?? "")
                Spacer()
                Button(action: actionSheet) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
            }
            HStack {
                Text("Hieght: ")
                Text(starWar.height ?? "")
            }
            HStack {
                Text("Mass: ")
                Text(starWar.mass ?? "")
            }
            HStack {
                Text("Eye Color: ")
                Text(starWar.eye_color ?? "")
            }
            HStack {
                Text("Hair Color: ")
                Text(starWar.hair_color ?? "")
            }
            HStack {
                Text("Skin Color: ")
                Text(starWar.skin_color ?? "")
            }
        }
    }
    func actionSheet() {
        guard let url = URL(string: starWar.image ?? "") else { return }
        let avtivity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(avtivity, animated: true, completion: nil)
    }
}
