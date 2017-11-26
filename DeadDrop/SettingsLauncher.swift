//
//  SettingsLauncher.swift
//  DeadDrop
//
//  Created by Kero on 2017/11/14.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit

enum EnumSetting: Int  {
    case settings = 0, account, logout, cancel
    static let count = 4
    var description: String {
        switch (self) {
        case .settings:
            return "Settings"
        case .account:
            return "My Account"
        case .logout:
            return "Logout"
        case .cancel:
            return "Cancel"
            
        }
    }
    var image: String {
        switch (self) {
        case .settings:
            return "Settings Image"
        case .account:
            return "Account Image"
        case .logout:
            return "Logout Image"
        case .cancel:
            return "Cancel Image"
        }
    }
}

class Setting {
    let name:String
    let imageName:String
    init(name:String,imageName:String){
        self.name = name
        self.imageName = imageName
    }
}

protocol SettingsLauncherDelegate {
    func didSelect(setting: EnumSetting)
}

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: SettingsLauncherDelegate?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight:CGFloat = 50
    
    let settings: [Setting] = {
        return [Setting(name: "My Account", imageName: "icon-29"),
                Setting(name: "Range Settings", imageName: "icon-20"),
                Setting(name: "Logout", imageName: "icon-29"),
                Setting(name: "Cancel", imageName: "icon-40")]
    }()
    
    let blackView = UIView()
    
    func showSettings() {
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height:CGFloat = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
        
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
            
        }
        
    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.2, animations: {
            self.blackView.alpha = 0
            // dismisses blackView
            
            if let window = UIApplication.shared.keyWindow{
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EnumSetting.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        
//        let setting = settings[indexPath.item]
//        cell.setting = setting
        
        cell.enumSetting = EnumSetting(rawValue: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? SettingsCell
        if let enumSetting = cell?.enumSetting {
            delegate?.didSelect(setting: enumSetting)
        }
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
        
    }
}
