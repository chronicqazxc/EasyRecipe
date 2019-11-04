//
//  Cache.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/8.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit

/// Abstract cache object, cache object in the memory.
class Cache<T: AnyObject> {
    fileprivate var cache = NSCache<NSString, T>()
    func updateCahe(_ object :T, for identifier: String) {
        cache.setObject(object, forKey: identifier as NSString)
    }
    func objectFor(identifier: String) -> T? {
        return cache.object(forKey: identifier as NSString)
    }
}

/// The cache class which specific in image cache.
class ImageCache: Cache<UIImage> {
    static let shared = ImageCache()
    func downloadImage(url: String, completeHandler: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            guard let imageURL = URL(string: url),
                let imageData = try? Data(contentsOf: imageURL),
                let image = UIImage(data: imageData) else {
                    completeHandler(nil)
                    return
            }
            self.updateCahe(image, for: url)
            DispatchQueue.main.async {
                completeHandler(image)
            }
        }
    }
}

/// The cache class which specific in Int cache.
class RatingCache: Cache<NSNumber> {
    static let shared = RatingCache()
    func updateRating(_ rating: Int, for identifier: String) {
        let rating = NSNumber(value: rating)
        cache.setObject(rating, forKey: identifier as NSString)
    }
    func ratingFor(identifier: String) -> Int? {
        guard let rating = cache.object(forKey: identifier as NSString) else {
            return nil
        }
        return rating.intValue
    }
}
