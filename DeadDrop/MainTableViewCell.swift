//
//  MainTableViewCell.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/26.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit

protocol MainTableViewCellDelegate{
    func didTapLike(_ tag:Int)
    func didTapDislike(_ tag:Int)}

class MainTableViewCell: UITableViewCell {
    
    var delegate: MainTableViewCellDelegate?
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var dislikeLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var dislikeButton: UIButton!
    
    
    
    @IBAction func likeBtnAct(_ sender:UIButton) {
        delegate?.didTapLike(sender.tag)
    }
    
    @IBAction func dislikeBtnAct(_ sender:UIButton) {
        delegate?.didTapDislike(sender.tag)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
