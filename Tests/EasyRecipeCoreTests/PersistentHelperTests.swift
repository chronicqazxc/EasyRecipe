//
//  EasyRecipeCoreTests.swift
//  EasyRecipeCoreTests
//
//  Created by Hsiao, Wayne on 2019/10/3.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import XCTest
@testable import EasyRecipeCore

class PersistentHelperTests: XCTestCase {
    
    let persistentHelper = PersistentHelper.shared

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        persistentHelper.deleteAll()
    }

    func testSaveAccountAndSaveRecipes() {
        let accountName = "Wayne Hsiao"
        let stinkyTofuName = "Stinky Tofu"
        let margaretName = "Margaret Pizza"
        guard let account = persistentHelper.newAccountWith(name: accountName),
            let stinkyTofu = persistentHelper.newRecipeWith(name: stinkyTofuName),
            let margaret = persistentHelper.newRecipeWith(name: margaretName) else {
                return
        }
        
        account.addToFavoriteRecipes(stinkyTofu)
        account.addToFavoriteRecipes(margaret)
        persistentHelper.save()

        let storedAccount = persistentHelper.accountBy(name: accountName)
        
        XCTAssertNotNil(storedAccount)
        XCTAssertEqual(storedAccount?.favoriteRecipes?.count, 2)
    }
    
    func testSetRecipeToMultiAccounts() {
        let account1Name = "Wayne"
        let account2Name = "Jack"
        let account3Name = "Peter"
        let stinkyTofuName = "Stinky Tofu"
        
        guard let account1 = persistentHelper.newAccountWith(name: account1Name) as? AnyHashable,
            let account2 = persistentHelper.newAccountWith(name: account2Name) as? AnyHashable,
            let account3 = persistentHelper.newAccountWith(name: account3Name) as? AnyHashable,
            let stinkyTofu = persistentHelper.newRecipeWith(name: stinkyTofuName) else {
                XCTFail()
                return
        }
        
        let accounts = Set<AnyHashable>(arrayLiteral: account1, account2, account3) as NSSet
        stinkyTofu.addToFavoritedBy(accounts)
        
        persistentHelper.save()
        
        guard let storedRecipe = persistentHelper.recipeBy(name: stinkyTofuName) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(storedRecipe.favoritedBy?.count, 3)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
