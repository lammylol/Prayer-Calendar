 //
//  UserProfileHolder.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/26/23.
//

import Foundation
import SwiftUI

@Observable class UserProfileHolder {
    // after sign-in, the 'person' will include userID, username, firstName, and lastName
    var person: Person = Person(username: "")
    var isLoggedIn: Bool = false
    var friendsList: [String] = []
    var userPassword: String = ""
    var pinnedPrayerRequests: [PrayerRequest] = []
    var refresh: Bool = false
    var viewState: ViewState?
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
    var isFinished: Bool {
        viewState == .finished
    }
}

extension UserProfileHolder {
    @Observable class Blank {
        var person: Person = Person(userID: "", username: "lammylol", email: "matthewthelam@gmail.com", firstName: "Matt", lastName: "Lam")
        var isLoggedIn: Bool = true
        var friendsList: [String] = []
        var userPassword: String = "abcdefghjikdas"
    }
}

extension UserProfileHolder {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}

@Observable class PrayerListHolder {
    var userID: String = "" // unknown if needed anymore.
    var prayerList: String = ""
    var prayStartDate = Date()
}

@Observable class DateHolder {
    var date = Date()
}
