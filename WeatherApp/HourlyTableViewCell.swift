//
//  HourlyTableViewCell.swift
//  WeatherApp
//
//  Created by lola on 4/24/16.
//  Copyright © 2016 LawrenceTran. All rights reserved.
//

import UIKit

let kHOURLY_TABLEVIEW_CELL_REUSE_IDENTIFIER = "com.lawrnce.HourlyTableViewCellReuseIdentifier"

class HourlyTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        timeLabel.text = ""
        temperatureLabel.text = ""
    }
}
