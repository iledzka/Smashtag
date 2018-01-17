//
//  SearchesTableViewCell.swift
//  Smashtag
//
//  Created by Iza Ledzka on 17/01/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class SearchesTableViewCell: UITableViewCell {

    @IBOutlet weak var search: UILabel!
    
    var savedSearch: String? { didSet { updateUI() } }
    
    private func updateUI() {
        search.text = savedSearch ?? ""
    }

}
