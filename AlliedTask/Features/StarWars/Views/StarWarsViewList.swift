//
//  ContentView.swift
//  AlliedTask
//
//  Created by Adel Aref on 12/11/2021.
//

import SwiftUI
struct StarWarsView: View {
    @ObservedObject private var viewModel = StarWarsViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.starWars ?? []) { star in
                    if viewModel.starWars != nil {
                        NavigationLink(destination: StarWarDetails(starWar: star)) {
                            StarWarRow(starWar: star)
                        }
                    } else {
                        LoadingView(isLoading: self.viewModel.isLoading, error: self.viewModel.error) {
                            self.viewModel.getStarWars()
                        }
                    }
                }.searchable(text: self.$viewModel.query)
                .navigationTitle("STAR WARS CATS")
            }
        }
        .onAppear {
            self.viewModel.getStarWars()
        }
    }
}
