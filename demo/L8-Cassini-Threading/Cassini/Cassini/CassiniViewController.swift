//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Dong, Vincent on 10/15/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        if primaryViewController.contents == self {
            if let ivc = secondaryViewController.contents as? ImageViewController, ivc.imageURL == nil {
                return true //I say I did it, but actually I did not (fake it)
            }
        }
        return false //
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let url = DemoURL.NASA[segue.identifier ?? ""] {
            if let imageViewController = segue.destination.contents as? ImageViewController {
                imageViewController.imageURL = url
                imageViewController.title = segue.identifier
            }
        }
    }

}

extension UIViewController {
    var contents: UIViewController {
        if let navCon = self as? UINavigationController {
            return navCon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
