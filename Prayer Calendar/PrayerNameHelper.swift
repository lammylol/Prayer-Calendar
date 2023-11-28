//
//  PrayerNameHelper.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/23/23.
//

import Foundation
import SwiftUI

class PrayerNameHelper {

//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        let menu = UIEditMenuInteraction.self
//                let newInstanceItem = UIMenuItem(title: "Comment", action:#selector(reportAFault))
//                menu.menuItems = [newInstanceItem]
//                menu.update()
//                if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(commentThisText){
//                    
//                    return true
//                }
//                return false
//        }
//        
//
//        
//        @objc func commentThisText() {
//                YOUR CODE
//        }
    
    // The following function returns an array of PrayerPerson's so that the view can grab both the username or name.
    func retrievePrayerPersonArray(prayerList: String) -> [PrayerPerson] {
        let ref = prayerList.components(separatedBy: "\n")
        var prayerArray: [PrayerPerson] = []
        
        for person in ref {
            let array = person.split(separator: "; ", omittingEmptySubsequences: true)
            /*.map(String.init)*/
            let prayerPerson = PrayerPerson(name: String(array.first ?? ""), username: String(array.last ?? ""))
            prayerArray.append(prayerPerson)
            print(prayerPerson.name)
        }
        
        return prayerArray
    }

}
