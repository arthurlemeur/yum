//
//  ParseHelper.swift
//  Makestagram
//
//  Created by Arthur Le Meur on 6/29/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse

// 1
class ParseHelper {
    
    // Following Relation
    static let ParseFollowClass       = "Follow"
    static let ParseFollowFromUser    = "fromUser"
    static let ParseFollowToUser      = "toUser"
    
    // Like Relation
    static let ParseLikeClass         = "Like"
    static let ParseLikeToPost        = "toPost"
    static let ParseLikeFromUser      = "fromUser"
    
    // Post Relation
    static let ParsePostUser          = "user"
    static let ParsePostCreatedAt     = "createdAt"
    
    // Flagged Content Relation
    static let ParseFlaggedContentClass    = "FlaggedContent"
    static let ParseFlaggedContentFromUser = "fromUser"
    static let ParseFlaggedContentToPost   = "toPost"
    
    // User Relation
    static let ParseUserUsername      = "username"
    
    // ...
    
    static func timelineRequestforCurrentUser(range: Range<Int>, completionBlock: PFArrayResultBlock) {
        
        let deliveryFromThisUser = Delivery.query()
        deliveryFromThisUser!.whereKey(ParsePostUser, equalTo: PFUser.currentUser()!)
        
        let query = PFQuery.orQueryWithSubqueries([deliveryFromThisUser!])
        query.includeKey(ParsePostUser)
        query.orderByDescending(ParsePostCreatedAt)
        
        // 2
        query.skip = range.startIndex
        // 3
        query.limit = range.endIndex - range.startIndex
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
//    static func likePost(user: PFUser, post: Post) {
//        let likeObject = PFObject(className: ParseLikeClass)
//        likeObject[ParseLikeFromUser] = user
//        likeObject[ParseLikeToPost] = post
//        
//        likeObject.saveInBackgroundWithBlock(nil)
//    }
    
//    static func unlikePost(user: PFUser, post: Post) {
//        let query = PFQuery(className: ParseLikeClass)
//        query.whereKey(ParseLikeFromUser, equalTo: user)
//        query.whereKey(ParseLikeToPost, equalTo: post)
//        
//        query.findObjectsInBackgroundWithBlock {
//            (results: [AnyObject]?, error: NSError?) -> Void in
//            if let error = error {
//                ErrorHandling.defaultErrorHandler(error)
//            }
//            
//            if let results = results as? [PFObject] {
//                for likes in results {
//                    likes.deleteInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
//                }
//            }
//        }
//    }
    // 1
//    static func likesForPost(post: Post, completionBlock: PFArrayResultBlock) {
//        let query = PFQuery(className: ParseLikeClass)
//        query.whereKey(ParseLikeToPost, equalTo: post)
//        // 2
//        query.includeKey(ParseLikeFromUser)
//        
//        query.findObjectsInBackgroundWithBlock(completionBlock)
//    }
    
    // MARK: Following
    
    /**
    Fetches all users that the provided user is following.
    
    :param: user The user whose followees you want to retrieve
    :param: completionBlock The completion block that is called when the query completes
    */

    
    /**
    Establishes a follow relationship between two users.
    
    :param: user    The user that is following
    :param: toUser  The user that is being followed
    */

    /**
    Deletes a follow relationship between two users.
    
    :param: user    The user that is following
    :param: toUser  The user that is being followed
    */

    
    // MARK: Users
    
    /**
    Fetch all users, except the one that's currently signed in.
    Limits the amount of users returned to 20.
    
    :param: completionBlock The completion block that is called when the query completes
    
    :returns: The generated PFQuery
    */
    static func allUsers(completionBlock: PFArrayResultBlock) -> PFQuery {
        let query = PFUser.query()!
        // exclude the current user
        query.whereKey(ParseHelper.ParseUserUsername,
            notEqualTo: PFUser.currentUser()!.username!)
        query.orderByAscending(ParseHelper.ParseUserUsername)
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
        return query
    }
    
    /**
    Fetch users whose usernames match the provided search term.
    
    :param: searchText The text that should be used to search for users
    :param: completionBlock The completion block that is called when the query completes
    
    :returns: The generated PFQuery
    */

    
    
}