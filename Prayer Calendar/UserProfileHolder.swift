 //
//  UserProfileHolder.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/26/23.
//

import Foundation
import SwiftUI

@Observable class UserProfileHolder {
    var person: PrayerPerson = PrayerPerson(username: "")
    var isLoggedIn: Bool = false
    var friendsList: [String] = []
}

@Observable class PrayerListHolder {
    var userID: String = ""
    var prayerList: String = ""
    var prayStartDate = Date()
}

@Observable class DateHolder {
    var date = Date()
}
