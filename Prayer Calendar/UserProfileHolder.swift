//
//  UserProfileHolder.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/26/23.
//

import Foundation
import SwiftUI

@Observable class UserProfileHolder {
//    var email: String = ""
    var userID: String = ""
    var person: PrayerPerson = PrayerPerson(username: "")
    var isLoggedIn: Bool = false
}

@Observable class PrayerListHolder {
    var date = Date()
    var userID: String = ""
    var email: String = ""
    
    var prayerListArray: [String] = [""]
    var prayerList: String = ""
    var prayStartDate = Date()
}
