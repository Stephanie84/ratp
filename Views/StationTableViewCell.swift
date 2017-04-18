//
//  StationTableViewCell.swift
//  wherMaTrain
//
//  Created by etudiant01 on 06/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameStationLabel: UILabel!
    
    var delegate : LineButtonDelegate?
    var indexPath : IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(lines: [Line]){
        print("lines number \(lines.count)")
         var initialX = 90
        for line in lines {
            let line1image = UIImage(named: "M_\(line.id)")
            let line1button = UIButton(type: .custom)
            line1button.setImage(line1image, for: .normal)
            line1button.tag = Int(line.id) ?? 0
            line1button.addTarget(self, action: #selector(StationTableViewCell.lineTapped), for: .touchUpInside)
            line1button.frame = CGRect(x: initialX, y: 90, width: 25, height: 25)
            self.addSubview(line1button)
            initialX += 50
                        
        }
    }
    func lineTapped(button: UIButton){
        delegate?.lineSelected(indexPath: indexPath, lineNumber: "\(button.tag)")
    }
    
    override func prepareForReuse() {
        for view in self.subviews {
            if view is UIButton {
                view.removeFromSuperview()
            }
        }
        //super.prepareForReuse()
    }
//    }

}

protocol LineButtonDelegate {
    func lineSelected(indexPath: IndexPath, lineNumber: String)
}
