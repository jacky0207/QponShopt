//
//  Feed.swift
//  Infoday
//
//  Created by 17200113 on 28/9/2018.
//  Copyright © 2018 Jacky Lam. All rights reserved.
//

import Foundation
import RealmSwift

class Coupon: Object {
    let id = RealmOptional<Int>()
    @objc dynamic var title: String? = nil
    @objc dynamic var restaurant: String? = nil
    @objc dynamic var district: String? = nil
    @objc dynamic var mall: String? = nil
    @objc dynamic var image: String? = nil
    @objc dynamic var coin: String? = nil
    @objc dynamic var till: String? = nil
    @objc dynamic var quota: String? = nil
    @objc dynamic var details: String? = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
