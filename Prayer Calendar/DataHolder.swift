import Foundation

class DataHolder: ObservableObject
{
    @Published var date = Date()
    @Published var prayerList: [String] = []
    @Published var prayerListString: String = ""
    @Published var dateDictionary: [Date: [String]] = [:]
    @Published var prayStartDate = Date()
    
//    init() {
////        self.prayStartDate = DataHolder.setDate(prayerStartDate: startDate)
//        self.prayerListString = prayerList.joined(separator: "\n")
//    }

    private static func setDate(prayerStartDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: prayerStartDate)!
    }
}
