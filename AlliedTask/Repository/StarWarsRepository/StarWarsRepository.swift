//
//  HomeRepo.swift
//  AlliedTask
//
//  Created by Adel Aref on 12/11/2021.
//

import Foundation

class StarWarsRepository: Repository {
    var networkClient: APIRouter
    var cacher: Cacher

    public init(_ client: APIRouter = NetworkClient()) {
        networkClient = client
        cacher = Cacher(destination: .atFolder("StarWarsRepository"))
    }
    func getStarWars(completion: @escaping RepositoryCompletion) {
        guard let url = Endpoint.getWarStars().url else { return }
        if let request = makeRequest(url: url, headers: nil, parameters: nil, query: nil, type: .get) {
            getData(withRequest: request,
                    name: String(describing: StarWarModel.self),
                    decodingType: MagixResponse<[StarWarModel]>.self, strategy:
                        .networkOnly, completion: completion)
        }
    }
}
