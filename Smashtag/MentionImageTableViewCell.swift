//
//  MentionImageTableViewCell.swift
//  Smashtag
//
//  Created by Iza Ledzka on 07/01/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class MentionImageTableViewCell: UITableViewCell {

   
    @IBOutlet weak var img: UIImageView!
    
    var item: MediaItem? {
        didSet{
            guard let item = item else { return }
            img.contentMode = .scaleAspectFit
            downloadImage(url: item.url)
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
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    private func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.img.image = UIImage(data: data)
            }
        }
    }

}
