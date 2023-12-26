//
//  CalendarHelper.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 9/26/23.
//

import Foundation
import FirebaseFirestore

class CalendarHelper
{
    let calendar = Calendar.current
    
    //This function retrieves PrayerList data from Firestore.
    func getFirestoreData(userHolder: UserProfileHolder, dataHolder: PrayerListHolder) async {
            let ref = Firestore.firestore()
                .collection("users")
                .document(userHolder.userID).collection("prayerList").document("prayerList1")
            
            ref.getDocument{(document, error) in
                if let document = document, document.exists {
                    
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: " + dataDescription)
                        
                        //Update Dataholder with PrayStartDate from Firestore
                        let startDateTimeStamp = document.get("prayStartDate") as! Timestamp
                        dataHolder.prayStartDate = startDateTimeStamp.dateValue()
                        
                        
                        //Update Dataholder with PrayerList from Firestore
                        dataHolder.prayerList = document.get("prayerList") as! String
                    
                } else {
                    print("Document does not exist")
                    dataHolder.prayerList = ""
                }
            }
    }
    
    // The following function returns an array of PrayerPerson's so that the view can grab both the username or name.
    func retrievePrayerPersonArray(prayerList: String) -> [PrayerPerson] {
        let ref = prayerList.components(separatedBy: "\n")
        var prayerArray: [PrayerPerson] = []
        
        for person in ref {
            let array = person.split(separator: "; ", omittingEmptySubsequences: true)
            /*.map(String.init)*/
            let prayerPerson = PrayerPerson(username: String(array.last ?? ""), firstName: String(array.first ?? ""))
            prayerArray.append(prayerPerson)
            print(prayerPerson.firstName)
        }
        
        return prayerArray
    }
    
    func plusMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value:1, to: date)!
    }
    
    func minusMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value:-1, to: date)!
    }
    
    func addDay(date: Date, count: Int) -> Date
    {
        return calendar.date(byAdding: .day, value:count, to: date)!
    }
    
    func monthString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    func yearString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func daysInMonth(date: Date) -> Int
    {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(date: Date) -> Int
    {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstDayOfMonth(date: Date) -> Date
    {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(date: Date) -> Int
    {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday!
    }
    
    func rangeOfPrayerStart(startDate: Date, firstDayOfMonth: Date) -> Int
    {
        let range = calendar.dateComponents([.day], from: startDate, to: firstDayOfMonth)
        return range.day!
    }
    
    func addToDictionary(date: Date, index: String, name: String, dictionary: inout [Date: [String]])
    {
        dictionary[date] = [index, name]
    }
}
