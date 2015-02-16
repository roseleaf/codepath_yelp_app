//
//  BusinessViewCell.swift
//  
//
//  Created by Rose Trujillo on 2/10/15.
//
//

import UIKit

class BusinessViewCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceRangeLabel: UILabel!
    
    var business: Business! {
        didSet {
            self.thumbImageView.setImageWithURL(NSURL(string: self.business.imageURL))
            self.nameLabel.text = self.business.name
            self.addressLabel.text = self.business.address[0] as? String
            self.distanceLabel.text = "\(self.business.distance)"
            self.ratingImageView.setImageWithURL( NSURL(string: self.business.ratingImageURL))
            self.ratingLabel.text = "\(self.business.numberOfReviews) reviews"
            self.categoryLabel.text = self.business.name
            self.priceRangeLabel.text = "$$"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
        self.thumbImageView.layer.cornerRadius = 35
        self.thumbImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
    }
}
