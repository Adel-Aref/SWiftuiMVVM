//
//  MagixResponse.swift
//  AlliedTask
//
//  Created by Adel Aref on 12/11/2021.
//

import Foundation

// swiftlint:disable all
struct MagixResponse<T: Codable>: Codable, Cachable {
    var fileName: String? = String(describing: T.self)
    var results: T?
}
