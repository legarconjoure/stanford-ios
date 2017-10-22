//
//  MentionsPopularityTableViewController.swift
//  SmashTag
//
//  Created by Dong, Vincent on 10/8/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit
import CoreData

class MentionsPopularityTableViewController: FetchedResultsTableViewController {
    
    var searchTerm: String? {
        didSet {
            updateUI()
        }
    }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
        didSet {
            updateUI()
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController<TwitterMention>?
    
    private func updateUI() {
        if let context = container?.viewContext {
            let request: NSFetchRequest<TwitterMention> = TwitterMention.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(key: "popularity", ascending: false),
                NSSortDescriptor(key: "keyword", ascending: true)
            ]
            fetchedResultsController = NSFetchedResultsController<TwitterMention>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Popularity Cell", for: indexPath)
        if let twitterMention = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = twitterMention.keyword
            cell.detailTextLabel?.text = String(twitterMention.popularity)
        }
        return cell
    }
}
