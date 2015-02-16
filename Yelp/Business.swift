//
//  Business.swift
//  Yelp
//
//  Created by Rose Trujillo on 2/9/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import Foundation

class Business {
    var imageURL :          String = ""
    var name:               String = ""
    var ratingImageURL :    String = ""
    var numberOfReviews:    Int = 0
    var address:            NSArray = [String]()
    var distance:           Int = 0
    var categories:         NSArray = [String]()
    
    init(dictionary: NSDictionary) {
        if (dictionary.objectForKey("image_url") != nil) {
            self.imageURL =     dictionary.objectForKey("image_url") as String
        } else {
            self.imageURL =     dictionary.objectForKey("snippet_image_url") as String
        }
        
        self.name     =     dictionary.objectForKey("name") as String
        self.ratingImageURL = dictionary.objectForKey("rating_img_url") as String
        self.numberOfReviews     =     dictionary.objectForKey("review_count") as Int
        self.address     =     dictionary.valueForKeyPath("location.display_address") as NSArray
        self.distance     =     dictionary.objectForKey("distance") as Int
        self.categories     =     dictionary.objectForKey("categories") as NSArray
    }
    
    class func businessesWithDictionaries(array: NSArray) -> [Business] {
        var businessArray =  [Business]()
        for  dictionary in array {
            var business = Business(dictionary: dictionary as NSDictionary)
            businessArray.append(business)
        }
        return businessArray
    }

}