//
//  PhotoCell.swift
//  InstagramParse
//
//  Created by Clark Kent on 3/6/16.
//  Copyright © 2016 Antonio Singh. All rights reserved.
//

import UIKit
import Parse

class PhotoCell: UITableViewCell {

    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    var Photos: PFObject! {
        didSet {
            let photoViewFile = Photos["media"] as? PFFile
            photoViewFile?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                if data != nil && error == nil {
                    self.postedImage.image = UIImage(data: data!)
                }
            })
            self.captionLabel.text = Photos["caption"] as? String
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
