//
//  TweetPicturesViewController.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 11/11/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import UIKit

class TweetPicturesViewController: UIViewController, DependencyInjectorUse {

    var currentScale: CGFloat = 1
    let cellAreaOneSideSize: CGFloat = 100.0
    
    var dependencyInjector: DependencyInjector?
    
    var viewModel: TweetsImagesModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "TweetInfoSegueID",
//            let tweetInfoVC = segue.destination as? TweetInfoTableTableViewController,
//            let cell = sender as? TweetImageCollectionViewCell,
//            let tweet = cell.tweet
//        {
//            tweetInfoVC.tweetInfoModel = TweetInfoModel(for: tweet)
//            dependencyInjector?.inject(to: tweetInfoVC)
//        }
        if segue.identifier == "SmashTweetTableSegueID" {
            if let tweetsVC = segue.destination as? SmashTweetTableViewController,
                let cell = sender as? TweetImageCollectionViewCell,
                let tweet = cell.tweet
            {
                dependencyInjector?.inject(to: tweetsVC)
                tweetsVC.insertTweets([tweet], forSearchRequest: "")
            }
        }
    }
    
    @IBAction func pinchAction(_ sender: UIPinchGestureRecognizer) {
    
        if sender.state == .began {
            sender.scale = currentScale
        } else {
            if sender.scale < 4 && sender.scale > 0.1 {
                currentScale = sender.scale
                collectionView.reloadData()
            }
        }
    }
}

extension TweetPicturesViewController: ITweetsImagesModelDelegate {
    func didLoad(imageWithIndex index: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: index, section: 0)
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}

extension TweetPicturesViewController: UICollectionViewDelegate {
    
}

extension TweetPicturesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.imagesCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetImageCollectionViewCell", for: indexPath) as! TweetImageCollectionViewCell
        if let image = viewModel?.image(atIndex: indexPath.row) {
            cell.imageView.image = image
        } else {
            cell.imageView.image = UIImage(named: "imagePlaceHolder-image")
        }
        cell.tweet = viewModel?.tweet(atIndex: indexPath.row)
        return cell
    }
}



extension TweetPicturesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageAspectRatio = viewModel?.imageAspectRatio(atIndex: indexPath.row) ?? 1
        
        let square = cellAreaOneSideSize * cellAreaOneSideSize * currentScale
        let width = sqrt(square * CGFloat(imageAspectRatio))
        let height = width / CGFloat(imageAspectRatio)
        return CGSize(width: width, height: height)
    }
}
