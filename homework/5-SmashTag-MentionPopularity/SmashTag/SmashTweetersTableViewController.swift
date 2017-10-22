//
//  SmashTweetersTableViewController.swift
//  SmashTag
//
//  Created by Dong, Vincent on 10/1/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit
import CoreData

class SmashTweetersTableViewController: FetchedResultsTableViewController {

    var mention: String? {
        didSet {
            updateUI()
        }
    }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
        didSet {
            updateUI()
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController<TwitterUser>?
    
    private func updateUI() {
        if let context = container?.viewContext { //want to do this on the main queue
            let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "handle", ascending: true)]
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@", mention!)
            fetchedResultsController = NSFetchedResultsController<TwitterUser>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUser Cell", for: indexPath)
        
        if let twitterUser = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = twitterUser.handle
            cell.detailTextLabel?.text = "\(twitterUser.tweets?.count ?? 0) tweets"
        }
        
        return cell
    }

}
