//
//  PrayerPerson.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/23/23.
//

import Foundation

struct PrayerPerson : Identifiable {
    let id = UUID()
    var name: String
    var username: String
}

extension PrayerPerson {
    static var blank: PrayerPerson {
        let item =
        PrayerPerson(name: "", username: "")
        return item
    }
    
    static var preview: PrayerPerson {
        let item =
        PrayerPerson(name: "Matt", username: "matthewthelam@gmail.com")
        return item
    }
}
