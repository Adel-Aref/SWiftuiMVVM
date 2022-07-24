//
//  NETWORK+ENDPOINTS.swift
//  AlliedTask
//
//  Created by Adel Aref on 12/11/2021.
//

import Foundation

extension Endpoint {
    static func getWarStars() -> Endpoint {
        return Endpoint(base: Environment.baseURL, path: "")
    }
}
