//
//  PrayerFeedView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 1/2/24.
//

import SwiftUI

struct PrayerFeedView: View {
    @State private var showSubmit: Bool = false
    @State private var showEdit: Bool = false
    
    @State var prayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.preview
    
    @Environment(UserProfileHolder.self) var userHolder
    
    func handleTap(prayerRequest: PrayerRequest) async {
        prayerRequestVar = prayerRequest
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("")
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: { showSubmit.toggle()
                                }) {
                                    Image(systemName: "plus")
                                }
                                .padding(.trailing, 15)
                            }
                        }
                    Spacer()
                    ForEach(prayerRequests) { prayerRequest in
                        PrayerRequestRow(prayerRequest: prayerRequest)
                            .onTapGesture {
                                Task {
                                    await handleTap(prayerRequest: prayerRequest)
                                }
                                self.showEdit.toggle()
                            }
                    }
                }
            }
            .navigationTitle("Sheep Feed")
            .navigationBarTitleDisplayMode(.automatic)
            .task {
                do {
                    prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: userHolder.person.userID)
                } catch {
                    
                }
            }
            
            .sheet(isPresented: $showSubmit, onDismiss: {
            }, content: {
                SubmitPrayerRequestForm(person: userHolder.person)
            })
            .sheet(isPresented: $showEdit, onDismiss: {
                Task {
                    do {
                        prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: userHolder.person.userID)
                    }
                }
            }, content: {
                EditPrayerRequestForm(prayerRequest: prayerRequestVar)
            })
        }
    }
}

#Preview {
    PrayerFeedView()
}
