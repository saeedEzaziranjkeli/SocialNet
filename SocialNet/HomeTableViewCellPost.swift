//
//  HomeTableViewCellPost.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 23/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit
import Firebase

class HomeTableViewCellPost: UITableViewCell {
    @IBOutlet weak var CommentTableView: ContentFittingTableView!
    @IBOutlet weak var userProfileViewImage: UIImageView!
    @IBOutlet weak var userPostLabel: UILabel!
    @IBOutlet weak var userCommentPostViewImage: UIImageView!
    @IBOutlet weak var userCommentLabel: UILabel!
    
}
