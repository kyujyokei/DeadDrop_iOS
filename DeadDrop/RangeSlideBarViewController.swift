//
//  RangeSlideBarViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/11/8.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit

class RangeSlideBarViewController: UIViewController {
    
    @IBOutlet weak var rangeLabel: UILabel!
    

    @IBAction func sliderAction(_ sender: UISlider) {
        rangeLabel.text = String(Int(sender.value))
    }
    
    
    @IBAction func deleteAccountBtnAct(_ sender: UIButton) {
    }
    
    
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        UserDefaults.standard.set(Int(rangeLabel.text!), forKey: "range")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
