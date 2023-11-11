//
//  PrayerRequest.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/10/23.
//

import Foundation

struct PrayerRequest : Identifiable {
    var id = UUID()
    
    var username: String
    var date: Date
    var prayerRequestText: String
    var status: String
}
