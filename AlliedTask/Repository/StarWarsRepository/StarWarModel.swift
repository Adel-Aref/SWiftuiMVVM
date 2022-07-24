//
//  MovieModel.swift
//  AlliedTask
//
//  Created by Adel Aref on 12/11/2021.
//

import Foundation
// swiftlint:disable all
struct StarWarModel: Identifiable, Codable {
    var id: String { name ?? "" }
    let name: String?
    let height: String?
    let mass: String?
    let hair_color: String?
    let skin_color: String?
    let eye_color: String?
    let gender: String?
    let birth_year: String?
    let image: String?
}
