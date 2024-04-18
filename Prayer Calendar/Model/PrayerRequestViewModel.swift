//
//  PrayerRequestViewModel.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 4/15/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

@Observable final class PrayerRequestViewModel {
    var prayerRequests: [PrayerRequest] = []
    var lastDocument: DocumentSnapshot? = nil
    var selectedStatus: statusFilter = .current
    var person: Person = Person()
    
    enum statusFilter: String, CaseIterable {
        case answered
        case current
        case noLongerNeeded
        case pinned
        case none
        
        var statusKey: String {
            return self.rawValue
        }
    }
    
    func statusFilter(option: statusFilter, person: Person) async throws {
        self.selectedStatus = option
        self.lastDocument = nil
        self.prayerRequests = []
        self.getPrayerRequests(person: person)
    }
    
    func getPrayerRequests(person: Person) {
        Task {
            let (newPrayerRequests, lastDocument) = try await PrayerFeedHelper().getPrayerRequestFeed(userID: person.userID, answeredFilter: selectedStatus.statusKey, count: 6, lastDocument: lastDocument)
            prayerRequests.append(contentsOf: newPrayerRequests)
            print("last document: " + String(lastDocument?.documentID ?? ""))
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
}
