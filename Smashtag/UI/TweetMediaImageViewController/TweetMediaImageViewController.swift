//
//  TweetMediaImageViewController.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 03/10/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import UIKit

class TweetMediaImageViewController: UIViewController
{
    var mediaImage: UIImage?
    @IBOutlet weak var tweetMediaImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if mediaImage != nil {
            scrollView.contentSize = mediaImage!.size
            tweetMediaImageView.frame = CGRect(x: 0, y: 0, width: mediaImage!.size.width, height: mediaImage!.size.height)
        }
        tweetMediaImageView.image = mediaImage
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize(scrollView.frame.size)
    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / tweetMediaImageView.bounds.width
        let heightScale = size.height / tweetMediaImageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = widthScale
    }
}

extension TweetMediaImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return tweetMediaImageView
    }
}
