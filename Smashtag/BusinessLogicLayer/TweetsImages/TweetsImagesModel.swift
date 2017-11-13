//
//  TweetsImagesModel.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 17/10/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import Foundation
import UIKit
import Twitter

enum TweetImagesModelError: Error {
    case DownloadError
}

protocol ITweetsImagesModelDelegate: NSObjectProtocol {
    func didLoad(imageWithIndex index: Int)
}

class TweetsImagesModel {
    private let mediaItems: [(mediaItem: Twitter.MediaItem, tweet: Twitter.Tweet)]
    private var imagesCache: NSCache<NSString, UIImage>
    
    weak var delegate: ITweetsImagesModelDelegate?
    
    var imagesCount: Int {
        return mediaItems.count
    }
    
    func tweet(atIndex index: Int) -> Twitter.Tweet? {
        guard index < mediaItems.count else { return nil }
        return mediaItems[index].tweet
    }

    func imageAspectRatio(atIndex index: Int) -> Double {
        guard index < mediaItems.count else { return 1 }
        return mediaItems[index].mediaItem.aspectRatio
    }
    
    func image(atIndex index: Int) -> UIImage? {
        guard index < mediaItems.count else { return nil }
        let imagePath = mediaItems[index].mediaItem.url.path as NSString
        
        if let cachedImage = imagesCache.object(forKey: imagePath) {
            return cachedImage
        } else {
            let imageURL = mediaItems[index].mediaItem.url
            downloadImage(fromURL: imageURL, withIndex: index, completionBlock: { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let image):
                    if let image = image {
                        strongSelf.imagesCache.setObject(image, forKey: imagePath)
                        strongSelf.delegate?.didLoad(imageWithIndex: index)
                    }
                case .fail(let error):
                    print("Image downloading error: \(error.localizedDescription)")
                }
            })
        }
        return nil
    }
    
    fileprivate func downloadImage(fromURL url: URL, withIndex imageIndex: Int, completionBlock: @escaping RequestCompletionClosure<UIImage?>) {
        DispatchQueue.global(qos: .utility).async{
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                completionBlock(.success(withObject: image))
            } else {
                completionBlock(.fail(withError: TweetImagesModelError.DownloadError))
            }
        }
    }
    
    init(withMediaItems mediaItems: [(mediaItem: Twitter.MediaItem, tweet: Twitter.Tweet)]) {
        self.mediaItems = mediaItems
        imagesCache = NSCache<NSString, UIImage>()
        imagesCache.countLimit = 100
    }
}
