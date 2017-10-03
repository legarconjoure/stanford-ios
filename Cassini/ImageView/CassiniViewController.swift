//
//  CassiniViewController.swift
//  ImageView
//
//  Created by Dong, Vincent on 8/2/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {

    // CHECK: missing this one here for the startup screen. (not detail but cassini)
    // The split view controler asks the delegate:
    // "would you like to do the job of collapsing the secondary view controller (detail)
    // on top of the primary view controller (master)

    // for the UISplitViewControllerDelegate method below to work
    // we have to set ourself as the UISplitViewController's delegate
    // (only we can be that because ImageViewControllers come and goes from the heap)
    // we could probably get away with doing this as late as viewDidLoad
    // but it's a bit safer to do it as early as possible
    // and this is as early as possible
    // (we just came out of the storyboard and "awoke"
    // so we know we are in our UISplitViewController by now)
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }

    // CHECK: don't understand this function here.
    // If there is imageURL there, I am gonna say I did it but I am not gonna do anything.
    // That's gonna cause it to not collapse. Collapse means detail on master.
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController
    ) -> Bool {
        if primaryViewController.content == self {
            if let ivc = secondaryViewController.content as? ImageViewController,
               ivc.imageURL == nil {
               return true // I did the collapse, but actually not...
            }
        }
        return false // you do it...I don't care.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if let identifier = segue.identifier, //CHECK: professor used DemoURL.NASA[segue.identifier ?? ""]
           let url = DemoURL.NASA[identifier] {
            if let imageVC = segue.destination.content as? ImageViewController {
                imageVC.imageURL = url
                imageVC.title = identifier
            }
            //CHECK: comment out the following
            // if let navigationController = segue.destination as? UINavigationController {
            //     navigationController.title = identifier
            // }
        }
    }

}

extension UIViewController {
    var content: UIViewController {
        if let controller = self as? UINavigationController {
            return controller.visibleViewController! //CHECK: professor used controller.visibleViewController ?? self
        } else {
            return self
        }
    }
}
