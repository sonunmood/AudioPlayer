//
//  SongTVCell.swift
//  AudioPlayer
//
//  Created by Sonun Usubalieva on 9/11/24.
//

import UIKit

class SongTVCell: UITableViewCell {

    static let identity: String = "SongTVCell"
    
    @IBOutlet weak var songNameLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .gray
    }
}
