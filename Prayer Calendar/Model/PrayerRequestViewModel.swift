//
//  PrayerRequestViewModel.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 4/15/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

@Observable final class PrayerRequestViewModel: ObservableObject {
    var prayerRequests: [PrayerRequest] = []
    var lastDocument: DocumentSnapshot? = nil
    var selectedStatus: statusFilter = .none
    var person: Person = Person()
    
    enum statusFilter: String, CaseIterable {
        case answered
        case current
        case noLongerNeeded
        case pinned
        case none
        
        var statusKey: String? {
            return self.rawValue
        }
    }
    
    func statusFilter(option: statusFilter) async throws {
        self.selectedStatus = option
        self.prayerRequests = []
        self.getPrayerRequests()
    }
    
    func getPrayerRequests() {
        Task {
            let (newPrayerRequests, lastDocument) = try await PrayerFeedHelper().getPrayerRequestFeed(userID: person.userID, answeredFilter: selectedStatus.statusKey!, count: 10, lastDocument: lastDocument)
            prayerRequests.append(contentsOf: newPrayerRequests)
            self.lastDocument = lastDocument
        }
    }
}
