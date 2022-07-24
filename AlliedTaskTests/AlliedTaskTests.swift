//
//  AlliedTaskTests.swift
//  AlliedTaskTests
//
//  Created by Adel Aref on 12/11/2021.
//

import XCTest
@testable import AlliedTask

class AlliedTaskTests: XCTestCase {
    let starWar = StarWarModel( name: "Luke Skywalker", height: "172",
                               mass: "77", hair_color: "blond", skin_color: "fair",
                               eye_color: "blue", gender: "male", birth_year: "19BBY", image: "")

    var sut: StarWarsViewModel! // system under test
    override func setUp() {
        sut = StarWarsViewModel()
    }
    // test star wars count happy use case
    func testStarWarsSuccess() {
        sut.starWars = [starWar]
        if let count = sut.starWars?.count {
            XCTAssert(count == 1, "Star wars count not equal 1")
        }
    }
    // test star wars count unhappy use case
    func testStarWarsFail() {
        sut.starWars = [starWar]
        if let count = sut.starWars?.count {
            XCTAssert(count != 2, "Star wars count not equal 2")
        }
    }
    // test star wars search happy use case
    func testSearchStarWarsSuccess() {
        sut.cahedStars = [starWar]
        sut.query = "Luke"
        if let count = sut.starWars?.count {
            XCTAssert(count == 1, "Star wars search result not equal 1")
        }
    }
    // test star wars search unhappy use case
    func testSearchStarWarsFail() {
        sut.cahedStars = [starWar]
        sut.query = "Nooooooooo"
        if let count = sut.starWars?.count {
            XCTAssert(count == 0, "Star wars search result not equal 0")
        }
    }
}
