//
//  TrackTVCell.swift
//  AudioPlayer
//
//  Created by Sonun Usubalieva on 9/11/24.
//

import UIKit

final class TrackTVCell: UITableViewCell {
    static let identity: String = "TrackTVCell"
    
    @IBOutlet weak var songNameLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .gray
    }
    
    func setData(_ data: Track) {
        songNameLbl.text = "\(data.artist)-\(data.trackName)"
        durationLbl.text = data.duration
    }
}
