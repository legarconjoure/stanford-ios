//
//  MasterViewController.swift
//  MasterDetail
//
//  Created by Dong, Vincent on 7/27/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let button = (sender as? UIButton)
            if button?.titleLabel?.text == "Detail" {
                print("in detail1")
            } else if button?.titleLabel?.text == "Detail2" {
                print("in detail2")
            }
        }
    }

}
