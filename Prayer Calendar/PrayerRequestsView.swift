//
//  PrayerRequestsView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/10/23.
//

import SwiftUI
import FirebaseFirestore

struct PrayerRequestsView: View {
    var prayerRequests = PrayerRequestModel.preview
    let db = Firestore.firestore()
    @State private var showView = false
    
    @Environment(PrayerList.self) var dataHolder
    @Environment(PrayerRequestViewModel.self) var viewModel
    
    var body: some View {
        VStack {
            List(viewModel.prayerRequests) { prayerRequest in
                PrayerRequestRow(prayerRequest: prayerRequest)
            }
            .overlay {
                if viewModel.prayerRequests.isEmpty {
                    ContentUnavailableView {
                        Label("No Prayer Requests", systemImage: "list.bullet.rectangle.portrait")
                    } description: {
                        Text("Start adding prayer requests to your list")
                    } actions: {
                        Button(action: { showView.toggle() })
                        {
                            Text("Add Prayer Request")
                        }
                    }
                    .frame(height: 250)
                    .offset(y: 120)
                }
            }
            .onAppear() {
                self.viewModel.retrievePrayerRequest(username: dataHolder.email)
            }
        }
        .frame(height: 250)
    }
    
//    func addPrayerRequest() {
//        showView.toggle()
////        
////        if showView {
//        SubmitPrayerRequestForm()
////                .transition(.move(edge: .bottom))
////                .animation(.spring(), value: showView)
//
//    }
}

#Preview {
    PrayerRequestsView(prayerRequests:
                        [PrayerRequest(username: "Matt", date: Date(), prayerRequestText: "Hello", status: "Current", firstName: "Matt", lastName: "Lam")]
    )
}

#Preview {
    PrayerRequestsView(prayerRequests: PrayerRequestModel.preview)
}
