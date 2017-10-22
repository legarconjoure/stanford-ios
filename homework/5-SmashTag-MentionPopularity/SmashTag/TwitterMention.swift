//
//  TwitterMention.swift
//  SmashTag
//
//  Created by Dong, Vincent on 10/8/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class TwitterMention: NSManagedObject {

    class func findOrCreateTwitterMention(matching mentions: [Twitter.Mention], in context: NSManagedObjectContext) throws -> NSSet {
        var results = [TwitterMention]()
        let resultSet = NSSet()

        for mention in mentions {
            let request: NSFetchRequest<TwitterMention> = TwitterMention.fetchRequest()
            request.predicate = NSPredicate(format: "keyword =[c] %@", mention.keyword)

            do {
                let matches = try context.fetch(request)
                if matches.count > 0 {
                    assert(matches.count == 1, "Database inconsistency")
                    matches[0].popularity += 1
                    continue
                }
            } catch {
                throw error
            }

            let twitterMention = TwitterMention(context: context)
            twitterMention.keyword = mention.keyword
            twitterMention.popularity = 1
            results.append(twitterMention)
        }
        return resultSet.addingObjects(from: results) as NSSet
    }
}
