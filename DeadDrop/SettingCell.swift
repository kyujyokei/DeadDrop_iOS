//
//  SettingCell.swift
//  DeadDrop
//
//  Created by Kero on 2017/11/15.
//  Copyright © 2017年 Kei. All rights reserved.
//

import Foundation
import UIKit

class BaseCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
//            print(isHighlighted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SettingsCell: BaseCell {
    
    var setting:Setting? {
        didSet{
            nameLabel.text = setting?.name
            
            if let imageName = setting?.name{
                iconImageView.image = UIImage(named: (imageName))
            }

        }
    }
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-29")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addContraintWothFormat(format: "H:|-16-[v0(30)]-8-[v1]-|", views: iconImageView,nameLabel)
        addContraintWothFormat(format: "V:|[v0]|", views: nameLabel)
        addContraintWothFormat(format: "V:|[v0(30)]|", views: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    

}
