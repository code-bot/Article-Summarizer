//
//  StoredArticlesTableViewCell.swift
//  Article Summarizer
//
//  Represents a cell in the table of articles
//
//  Created by Sahaj Bhatt on 3/21/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit

class StoredArticlesTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var articleTitle = ""
    var articleAuthor = ""
    var articleDate = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Set cell information
        titleLabel.text = articleTitle
        authorLabel.text = articleAuthor
        dateLabel.text = articleDate
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
