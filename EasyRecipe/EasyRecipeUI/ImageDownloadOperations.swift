//
//  AppOperations.swift
//  OperationDemo
//
//  Created by Hsiao, Wayne on 2019/5/9.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//
//  This file coming from my private project [LazyLoading](https://github.com/chronicqazxc/LazyLoading).

import UIKit

public enum IconDownloadStatus {
    case new, downloaded, failed
}
public enum OperationStatus {
    case cancel, finished
}


/// An operation object which in charge of download the image and return the download status.
public class IconDownloader: Operation {
    var icon: DownloadableIcon
    var iconDownloadStatus = IconDownloadStatus.new
    var image: UIImage?
    
    init(_ icon: DownloadableIcon) {
        self.icon = icon
    }
    
    /// https://developer.apple.com/documentation/foundation/operation/1413540-isfinished
//    override var isFinished: Bool {
//        if image == nil {
//            return false
//        } else {
//            return true
//        }
//    }
    
    override public func main() {
        if let cachedImage = ImageCache.shared.objectFor(identifier: icon.imageURL) {
            iconDownloadStatus = .downloaded
            image = cachedImage
            return
        }
        
        if isCancelled {
            assert(image != nil, "image should not be nil.")
            return
        }
        
        do {
            guard let url = URL(string: icon.imageURL), isCancelled == false else {
                return
            }
            
            let imageData = try Data(contentsOf: url)
            
            if !imageData.isEmpty {
                image = UIImage(data: imageData)
                assert(image != nil, "image should not be nil.")
                iconDownloadStatus = .downloaded
                if let image = image {
                    ImageCache.shared.updateCahe(image, for: icon.imageURL)
                }
            } else {
                image = nil
                iconDownloadStatus = .failed
            }
        } catch {
            image = nil
            iconDownloadStatus = .failed
        }
        
    }
}

/// Control a bunch of DownloaderOperations, start cancel etc. Which intend to implement the lazy loading pattern.
public class PendingIconDownloaderOperations {
    /// Data Source
    fileprivate var appIconDownloaders = [IconDownloader]()
    typealias Key = AnyHashable
    /// Control respective AppIconDownloaders
    fileprivate var downloadsInProgress = [Key: IconDownloader]()
    fileprivate lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    var count: Int {
        return appIconDownloaders.count
    }
    
    subscript (index: Int) -> IconDownloader {
        get {
            let downloader = appIconDownloaders[index]
            if downloader.isCancelled == true {
                let newDownloader = IconDownloader(downloader.icon)
                appIconDownloaders[index] = newDownloader
            }
            return appIconDownloaders[index]
        }
        set {
            appIconDownloaders[index] = newValue
        }
    }
    
    func startDownload(for appIconDownloader: IconDownloader,
                       at key: Key,
                       completeHandler: @escaping (OperationStatus)->Void) {
        guard appIconDownloader.iconDownloadStatus == .new else {
            return
        }
        
        guard downloadsInProgress[key] == nil else {
            return
        }
        appIconDownloader.completionBlock = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if appIconDownloader.isCancelled {
                completeHandler(.cancel)
            }
            DispatchQueue.main.async {
//                if appIconDownloader.isFinished && !appIconDownloader.isCancelled {
//                    appIconDownloader.main()
//                    return
//                }
                strongSelf.downloadsInProgress.removeValue(forKey: key)
                completeHandler(.finished)
            }
        }
        if !downloadQueue.operations.contains(appIconDownloader) {
            downloadQueue.addOperation(appIconDownloader)
        }
        downloadsInProgress[key] = appIconDownloader
    }
    
    func cancel(at keys: [Key]) {
        for key in keys {
            if let pendingDownload = downloadsInProgress[key] {
                pendingDownload.cancel()
                downloadsInProgress.removeValue(forKey: key)
            }
        }
    }
    
    func suspendAllOperations() {
        downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        downloadQueue.isSuspended = false
    }

    func loadImagesForOnScreenCells(indexPathsForVisibleRows pathes: [IndexPath],
                                    completeHander: @escaping ([IndexPath])->Void) {

        guard let allPendingOperations = Set(downloadsInProgress.keys) as? Set<IndexPath> else {
            return
        }
        //            allPendingOperations.formUnion(allPendingOperations)

        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(pathes)
        toBeCancelled.subtract(visiblePaths)

        var toBeStart = visiblePaths
        toBeStart.subtract(allPendingOperations)

        cancel(at: Array(toBeCancelled))

        for indexPath in toBeStart {
            guard indexPath.row < self.count else {
                continue
            }
            let appIconDownloader = self[indexPath.row]
            startDownload(for: appIconDownloader, at: indexPath) {
                if $0 == .finished {
                    DispatchQueue.main.async {
                        completeHander([indexPath])
                    }
                }
            }
        }
    }
}

extension PendingIconDownloaderOperations {
    convenience init(downloaders: [IconDownloader]) {
        self.init()
        self.appIconDownloaders = downloaders
    }
}
