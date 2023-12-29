//
//  PrayerPerson.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/23/23.
//

import Foundation

struct PrayerPerson {
    var userID: String = ""
    var username: String
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
}

extension PrayerPerson {
    static var blank: PrayerPerson {
        let item =
        PrayerPerson(username: "")
        return item
    }
    
    static var preview: PrayerPerson {
        let item =
        PrayerPerson(username: "matthewthelam@gmail.com", firstName: "Matt", lastName: "Lam")
        return item
    }
}
