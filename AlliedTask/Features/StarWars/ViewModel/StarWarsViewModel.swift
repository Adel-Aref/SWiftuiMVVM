//
//  MovieViewModel.swift
//  AlliedTask
//
//  Created by Adel Aref on 12/11/2021.
//

import Foundation
class BaseViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: NSError?

}
class StarWarsViewModel: BaseViewModel {
    let repository: Repository
    @Published var starWars: [StarWarModel]?
    @Published var query = "" {
        didSet {
            search(query: query)
        }
    }

    var cahedStars = [StarWarModel]()
    var isEmptyResults: Bool {
        !self.query.isEmpty && self.starWars != nil && self.starWars!.isEmpty
    }
    public init (_ repo: Repository = StarWarsRepository()) {
        repository = repo
        super.init()
        self.getStarWars()
    }

    func getStarWars() {
        self.isLoading = true
        self.starWars = nil
        (repository as? StarWarsRepository)?.getStarWars { [weak self] (result) in
            guard let self = self else {
                return
            }
            self.isLoading = false
            switch result {
            case .success(let data):
                if let data = data as? MagixResponse<[StarWarModel]> {
                    if let result = data.results {
                        self.cahedStars = result
                        self.starWars = result
                    }
                }
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    // local search because there isn't search API
    func search(query: String) {
        var vms = [StarWarModel]()
        self.isLoading = false
        self.error = nil

        guard !query.isEmpty else {
            self.starWars = self.cahedStars
            return
        }
        self.isLoading = true
        self.cahedStars.forEach { star in
            if let name = star.name?.capitalized {
                if name.hasPrefix(query.capitalized) {
                    vms.append(star)
                }
            }
        }
        isLoading = false
        starWars = vms
    }
}
