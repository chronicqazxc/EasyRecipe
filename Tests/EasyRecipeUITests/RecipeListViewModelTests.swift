//
//  RecipeListViewModelTests.swift
//  EasyRecipeUITests
//
//  Created by Hsiao, Wayne on 2019/10/6.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import XCTest
@testable import EasyRecipeUI
import EasyRecipeCore
import ProfileCore

class RecipeListViewModelTests: XCTestCase {
    
    var expectation: XCTestExpectation!
    let service = MockService()

    override func setUp() {
        expectation = expectation(description: "SomeService does stuff and runs the callback closure")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetRecipes() {
        
        let viewModel = RecipeListViewModel(service: service)

        viewModel.getRecipeCallback = { [unowned self] (_, _) -> Void in
            self.expectation.fulfill()
        }
        
        viewModel.getRecipes()

        waitForExpectations(timeout: 5.0) { error in
            XCTAssertNotNil(viewModel.items)
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testSelectedRecipe() {
        let viewModel = RecipeListViewModel(service: service)
        viewModel.getRecipeCallback = { [unowned self] (_, _) -> Void in
            self.expectation.fulfill()
        }
        viewModel.getRecipes()
        
        waitForExpectations(timeout: 5.0) { error in
            
            viewModel.tableView(didSelectRowAt: IndexPath(row: 0, section: 0))
            XCTAssertEqual(viewModel.selectedRecipe?.name, "Taiwanese Three Cup Chicken")
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFavoriteButtonTappedAndIsFavorited() {
        Profile.current = Profile(firstName: "test", lastName: "account", email: "")
        let index = IndexPath(row: 0, section: 0)
        let viewModel = RecipeListViewModel(service: service)
        viewModel.getRecipes()
        viewModel.favoriteButtonTapped(indexPath: index) { (updateSuccess) in
            self.expectation.fulfill()
        }
            
        waitForExpectations(timeout: 5.0) { error in
            
            let recipe = viewModel.items[index.row]
            
            XCTAssertTrue(viewModel.isFavorited(recipe))
            
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testRecipeNameBy() {

        let viewModel = RecipeListViewModel(service: service)
        viewModel.getRecipeCallback = { [unowned self] (_, _) -> Void in
            self.expectation.fulfill()
        }
        viewModel.getRecipes()
        
        waitForExpectations(timeout: 5.0) { error in
            
            let index = IndexPath(row: 0, section: 0)
            XCTAssertEqual(viewModel.recipeNameBy(indexPath: index), "Taiwanese Three Cup Chicken")
            
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

}
