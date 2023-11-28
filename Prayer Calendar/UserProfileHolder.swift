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
    var uid: String = ""
    var person: PrayerPerson = PrayerPerson(name: "", username: "")
    var isLoggedIn: Bool = false
}

@Observable class PrayerListHolder {
    var date = Date()
    var email: String = ""
    var uid: String = ""
    
    var prayerListArray: [String] = [""]
    var prayerList: String = ""
    var prayStartDate = Date()
}
