//
//  Tweet.swift
//  SmashTag
//
//  Created by Dong, Vincent on 10/1/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject {
    class func findOrCreateTweet(matching twitterInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> Tweet {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        //no order needed so no sort descriptors
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count <= 1, "Tweet.findOrCreateTweet -- database inconsistency")
                return matches[0]
            }
        } catch {
            //Don't what to do here, so re-throw the error to the caller
            throw error
        }
        
        //if we are here, no matches, then create it
        let tweet = Tweet(context: context)
        tweet.unique = twitterInfo.identifier
        tweet.text = twitterInfo.text
        tweet.created = twitterInfo.created
        tweet.tweeter = try? TwitterUser.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)

        return tweet
    }
}
