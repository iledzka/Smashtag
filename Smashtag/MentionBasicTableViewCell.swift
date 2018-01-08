//
//  MentionBasicTableViewCell.swift
//  Smashtag
//
//  Created by Iza Ledzka on 07/01/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

//This cell is used in Mentions Table View and can store hashtag, url or user mention.
class MentionBasicTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    var item: Mention? {
        didSet{
            guard let item = item else { return }
            title.text = item.keyword
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
