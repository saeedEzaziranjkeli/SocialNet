//
//  ContentFittingTableView.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 19/08/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit


protocol ContentFittingTableViewDelegate: UITableViewDelegate {
    func tableViewDidUpdateContentSize(_ tableView: UITableView)
}

class ContentFittingTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            if !constraints.isEmpty {
                invalidateIntrinsicContentSize()
            } else {
                sizeToFit()
            }
            
            if contentSize != oldValue {
                if let delegate = delegate as? ContentFittingTableViewDelegate {
                    delegate.tableViewDidUpdateContentSize(self)
                }
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return contentSize
    }
}
