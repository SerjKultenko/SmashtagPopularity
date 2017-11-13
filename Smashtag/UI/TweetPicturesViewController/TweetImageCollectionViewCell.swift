//
//  TweetImageCollectionViewCell.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 12/11/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import UIKit
import Twitter

class TweetImageCollectionViewCell: UICollectionViewCell {
    var tweet: Twitter.Tweet?
    
    @IBOutlet weak var imageView: UIImageView!
    
}
