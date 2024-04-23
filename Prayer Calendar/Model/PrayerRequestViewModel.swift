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
    var scrollViewID = UUID()
    var progressStatus: Bool = false
    var viewState: ViewState?
    var queryCount: Int = 0
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
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
//        self.scrollViewID = UUID()
//        await self.getPrayerRequests(person: person)
    }
    
    func getPrayerRequests(person: Person) async {
        
        viewState = .loading
        defer { viewState = .finished }
        
        do {
//            try await self.statusFilter(option: selectedStatus, person: person)
            let (newPrayerRequests, lastDocument) = try await PrayerFeedHelper().getPrayerRequestFeed(userID: person.userID, answeredFilter: selectedStatus.statusKey, count: 6, lastDocument: nil)
            
            prayerRequests = newPrayerRequests
            self.queryCount = newPrayerRequests.count
            
            if lastDocument != nil {
                self.lastDocument = lastDocument
            }
        } catch {
            print(error)
        }
        print("last document: " + String(lastDocument?.documentID ?? ""))
        
    }
    
    func getNextPrayerRequests(person: Person) async {
        
        guard queryCount == 6 else { return }
            
        viewState = .fetching
        defer { viewState = .finished }
        
        do {
            let (newPrayerRequests, lastDocument) = try await PrayerFeedHelper().getPrayerRequestFeed(userID: person.userID, answeredFilter: selectedStatus.statusKey, count: 6, lastDocument: lastDocument)
            
            self.queryCount = newPrayerRequests.count
            
            prayerRequests.append(contentsOf: newPrayerRequests)
            
            if lastDocument != nil {
                self.lastDocument = lastDocument
            }

        } catch {
            print(error)
        }
        print("last document: " + String(lastDocument?.documentID ?? ""))

    }
    
    func hasReachedEnd(of prayerRequest: PrayerRequest) -> Bool {
        prayerRequests.last?.id == prayerRequest.id
    }
}

extension PrayerRequestViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}
