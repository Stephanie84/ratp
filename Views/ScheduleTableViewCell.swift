//
//  ScheduleTableViewCell.swift
//  wherMaTrain
//
//  Created by etudiant01 on 07/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
   

   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutMargins = UIEdgeInsets.zero

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
