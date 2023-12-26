//
//  PrayerNameHelper.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/23/23.
//

import Foundation
import SwiftUI

//class PrayerNameHelper {
    
    // The following function returns an array of PrayerPerson's so that the view can grab both the username or name.
//    func retrievePrayerPersonArray(prayerList: String) -> [PrayerPerson] {
//        let ref = prayerList.components(separatedBy: "\n")
//        var prayerArray: [PrayerPerson] = []
//        
//        for person in ref {
//            let array = person.split(separator: "; ", omittingEmptySubsequences: true)
//            /*.map(String.init)*/
//            let prayerPerson = PrayerPerson(name: String(array.first ?? ""), username: String(array.last ?? ""))
//            prayerArray.append(prayerPerson)
//            print(prayerPerson.name)
//        }
//        
//        return prayerArray
//    }
//
//}
