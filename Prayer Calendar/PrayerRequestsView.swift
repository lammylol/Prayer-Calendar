//
//  PrayerRequestsView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/10/23.
//

// This is the view to capture the list of prayer requests.

import SwiftUI
import FirebaseFirestore

struct PrayerRequestsView: View {
//    var prayerRequests: [PrayerRequest]
    let db = Firestore.firestore()
    @State private var showView: Bool = false
    @State private var showEdit: Bool = false
    @State var username: String
    
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.preview
    
    @Environment(PrayerListHolder.self) var dataHolder
    @Environment(PrayerRequestsHolder.self) var viewModel
    
    func handleTap(prayerRequest: PrayerRequest) async {
        prayerRequestVar = prayerRequest
    }
    
    var body: some View {
        
        VStack {
            List(viewModel.prayerRequests) { prayerRequest in
                PrayerRequestRow(prayerRequest: prayerRequest)
                    .onTapGesture {
                        Task {
                            await handleTap(prayerRequest: prayerRequest)
                        }
                        self.showEdit.toggle()
                    }
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
                self.viewModel.retrievePrayerRequest(username: username) // this is the line to uncheck when wanting to view preview
            }
        }
        .sheet(isPresented: $showEdit) {
            EditPrayerRequestForm(prayerRequest: prayerRequestVar)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//#Preview {
//    PrayerRequestsView(prayerRequests:
//                        [PrayerRequest(username: "Matt", date: Date(), prayerRequestText: "Hello", status: "Current", firstName: "Matt", lastName: "Lam")]
//    ).environment(PrayerList())
//    .environment(PrayerRequestViewModel())
//}

#Preview {
    PrayerRequestsView(username: "matthewthelam@gmail.com")
        .environment(PrayerListHolder())
        .environment(PrayerRequestsHolder())
}
