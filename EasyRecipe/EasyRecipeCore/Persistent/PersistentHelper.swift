//
//  PersistentHelper.swift
//  EasyRecipeCore
//
//  Created by Hsiao, Wayne on 2019/10/3.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import CoreData
import Foundation

/// Abstract persistent layer protocol should be implemented.
public protocol PersistentProtocol {
    
    /// Save chnaged context.
    func save()
    
    /// Delete entire entity.
    /// - Parameter entity: Type of entity which should be deleted.
    func delete(_ entity: AnyObject.Type)
    
    /// Delete all entities.
    func deleteAll()
}


/// Abstract methods for Account
public protocol RecipeUserHelper {
    
    /// Generate a new account object, the save operation should be called manually.
    /// - Parameter name: Name of the account.
    func newAccountWith(name: String) -> AccountWrapper?
    
    /// Return a stored acocunt.
    /// - Parameter name: Name of the account.
    func accountBy(name: String) -> AccountWrapper?
    
    /// Return all accounts in the store.
    func accounts() -> [AccountWrapper]
}

/// Abstract method for Recipe
public protocol RecipeListHelper {
    
    /// Generate a new recipe object, the save operation should be called manually.
    /// - Parameter name: Name of the recipe.
    func newRecipeWith(name: String) -> RecipeWrapper?
    
    /// Return a stored recipe.
    /// - Parameter name: Name of the recipe.
    func recipeBy(name: String) -> RecipeWrapper?
    
    /// Return all recipes in the store.
    func recipes() -> [RecipeWrapper]
}

/// Persistent layer wrapper which intend to hide the persistent method from client, in order to change store logic without impact client code.
public class PersistentHelper: PersistentProtocol {
    
    public static let shared = PersistentHelper()
    
    let bundle = Bundle(for: PersistentHelper.self)
    
    lazy fileprivate var container: NSPersistentContainer = {
        guard let objectModel = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            return NSPersistentContainer(name: "EasyRecipe")
        }
        return NSPersistentContainer(name: "EasyRecipe", managedObjectModel: objectModel)
    }()
    
    lazy fileprivate var context = {
        return container.viewContext
    }()
    
    fileprivate init() {
        loadStores()
    }
    
    fileprivate func loadStores() {
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    public func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    public func delete(_ entity: AnyObject.Type) {
        do {
            if let coreDataEntity = entity as? NSManagedObject.Type {
                let request = NSBatchDeleteRequest(fetchRequest: coreDataEntity.fetchRequest())
                try context.execute(request)
                save()
            }
        } catch {
            print(error)
        }
    }
    
    public func deleteAll() {
        for entityType in [
            AccountModel.self,
            RecipeModel.self
            ] as [NSManagedObject.Type] {
                delete(entityType)
        }
    }
}

extension PersistentHelper: RecipeUserHelper {
    public func newAccountWith(name: String) -> AccountWrapper? {
        guard let description = NSEntityDescription.entity(forEntityName: "AccountModel", in: context) else {
            return nil
        }
        let account = AccountModel(entity: description, insertInto: context)
        account.name = name
        return account
    }
    
    public func accountBy(name: String) -> AccountWrapper? {
        let fetchRequest = AccountModel.fetchRequest() as NSFetchRequest<AccountModel>
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let account = try context.fetch(fetchRequest).first
            return account
        } catch {
            print(error)
        }
        return nil
    }
    
    public func accounts() -> [AccountWrapper] {
        do {
            
            let accounts = try context.fetch(AccountModel.fetchRequest())
            return accounts as! [AccountModel]
        } catch {
            print(error)
            return []
        }
    }
}

extension PersistentHelper: RecipeListHelper {
    public func newRecipeWith(name: String) -> RecipeWrapper? {
        guard let description = NSEntityDescription.entity(forEntityName: "RecipeModel", in: context) else {
            return nil
        }
        let recipe = RecipeModel(entity: description, insertInto: context)
        recipe.name = name
        return recipe
    }
    
    public func recipeBy(name: String) -> RecipeWrapper? {
        let fetchRequest = RecipeModel.fetchRequest() as NSFetchRequest<RecipeModel>
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let recipe = try context.fetch(fetchRequest).first
            return recipe
        } catch {
            print(error)
        }
        return nil
    }
    
    public func recipes() -> [RecipeWrapper] {
        do {
            let recipes = try context.fetch(RecipeModel.fetchRequest())
            return recipes as! [RecipeWrapper]
        } catch {
            print(error)
            return []
        }
    }
}

extension PersistentHelper {
    static public func persistentProfile(_ identifier: String) -> AccountWrapper? {
        guard let persistedAccount = PersistentHelper.shared.accountBy(name: identifier) else {
            return PersistentHelper.shared.newAccountWith(name: identifier)
        }
        return persistedAccount
    }
    
    public static func persistentRecipe(_ identitifer: String) -> RecipeWrapper? {
        guard let persistedRecipe = PersistentHelper.shared.recipeBy(name: identitifer) else {
            return PersistentHelper.shared.newRecipeWith(name: identitifer)
        }
        return persistedRecipe
    }
}
