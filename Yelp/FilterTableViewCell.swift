//
//  FilterTableViewCell.swift
//  Yelp
//
//  Created by Rose Trujillo on 2/15/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

protocol FilterTableViewCellDelegate {
    func switchCellValueDidChange(filterCell: FilterTableViewCell, value: Bool)
}

class FilterTableViewCell: UITableViewCell {
    var delegate: FilterTableViewCellDelegate!
    var on: Bool!
    @IBOutlet weak var filterSwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setOn(on: Bool){
        self.setOnAnimated(on, animated: false)
    }
    func setOnAnimated(on: Bool, animated: Bool){
        self.filterSwitch.setOn(on, animated: false)
        self.on = on;
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func switchValueChanged(sender: AnyObject) {
        delegate?.switchCellValueDidChange(self, value: self.filterSwitch.on)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
