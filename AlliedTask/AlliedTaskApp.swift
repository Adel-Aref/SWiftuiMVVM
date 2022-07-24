//
//  AlliedTaskApp.swift
//  AlliedTask
//
//  Created by Adel Aref on 12/11/2021.
//

import SwiftUI

@main
struct AlliedTaskApp: App {
    let viewModel = StarWarsViewModel()

    var body: some Scene {
        WindowGroup {
            StarWarsView()
        }
    }
}
