//
//  superVC.swift
//  Time Tracker
//
//  Created by Mikhailo Dovhyi on 12.02.2021.
//

import UIKit

class superVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func makeTwo(int: Int) -> String {
        return int <= 9 ? "0\(int)" : "\(int)"
    }
    func dateFrom(sting: String) -> Date? {
        print("dateFrom", sting)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat
        let date = dateFormatter.date(from: sting)
        return date
    }
    
    func stringToDate(from: String) -> DateComponents {
        let formater = DateFormatter()
        formater.dateFormat = DateFormat
        let pressedHours = formater.date(from: from)
        if let date = pressedHours {
            return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        } else {
            print(Date(), "jhgfghjk")
            return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        }
    }
    
    func nowToString() -> String {
        let now = Date()
        let formater = DateFormatter()
        formater.dateFormat = DateFormat
        return formater.string(from: now)
    }
    
    
    func differenceFromNow(startDate: Date, difference: Int = 0) -> DateStruct {
        var now = Date()
        if difference == 0 {
            let dif = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startDate, to: now)
            return DateStruct(year: dif.year ?? 0, month: dif.month ?? 0, day: dif.day ?? 0, hour: dif.hour ?? 0, minute: dif.minute ?? 0, second: dif.second ?? 0)
        } else {
            now.addTimeInterval(TimeInterval(difference))
            let dif = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startDate, to: now)
            return DateStruct(year: dif.year ?? 0, month: dif.month ?? 0, day: dif.day ?? 0, hour: dif.hour ?? 0, minute: dif.minute ?? 0, second: dif.second ?? 0)
        }
    }
    
    
    
    
    var startPressedDate: String? {
        set{
            UserDefaults.standard.set(newValue, forKey: "StartPressedDate")
            print("value for StartPressedDate: setted (\(newValue ?? "nothing"))")
        }
        get{
            return UserDefaults.standard.value(forKey: "StartPressedDate") as? String
        }
    }
    
    var newTimerDate: String? {
        set{
            UserDefaults.standard.set(newValue, forKey: "newTimerDate")
            print("value for newTimerDate: setted (\(newValue ?? "nothing"))")
        }
        get{
            return UserDefaults.standard.value(forKey: "newTimerDate") as? String
        }
    }
    
    var workLimit: Int {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "workLimitHours")
        }
        get {
            return UserDefaults.standard.value(forKey: "workLimitHours") as? Int ?? 12
        }
    }
    
    var stopStartDefference: [Int] {
        set {
            print(newValue, "stopStartDefference")
            UserDefaults.standard.setValue(newValue, forKey: "stopStartDefference")
        }
        get {
            return UserDefaults.standard.value(forKey: "stopStartDefference") as? [Int] ?? []
        }
    }
    
    
    
    func createTestData() {
        let testData: [[String: Any]] = [
            ["name": "Work",
            "amount": [7, 40, 50],
            "dateFrom": "2021-02-12 1:10:10 PM",
            "dateTo": "2021-02-12 9:51:00 PM",
            "workName": "work",
            "data": [
                ["periud": "13:10:10 - 14:10:10",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"]
            ],
            "color": "red"
            ],
            ["name": "Work",
            "amount": [9, 10, 12],
            "dateFrom": "2021-02-11 4:10:10 PM",
            "dateTo": "2021-02-11 2:51:00 AM",
            "data": [
                ["periud": "4:10:10 - 10:10:10",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"]
            ],
            "color": "red"
            ],
            ["name": "Work",
            "amount": [13, 14, 12],
            "dateFrom": "2021-02-10 10:10:10 AM",
            "dateTo": "2021-02-10 11:51:00 PM",
            "data": [
                ["periud": "10:10:10 - 14:10:10",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"]
            ],
            "color": "red"
            ],
            ["name": "Work",
            "amount": [13, 10, 12],
            "dateFrom": "2021-02-09 10:10:10 AM",
            "dateTo": "2021-02-09 11:51:00 PM",
            "data": [
                ["periud": "10:10:10 - 14:10:10",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"]
            ],
            "color": "red"
            ],
            ["name": "Work",
            "amount": [12, 10, 12],
            "dateFrom": "2021-02-08 10:10:10 AM",
            "dateTo": "2021-02-08 11:51:00 PM",
            "data": [
                ["periud": "10:10:10 - 14:10:10",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "not"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"]
            ],
            "color": "red"
            ],
            ["name": "Work",
            "amount": [13, 10, 12],
            "dateFrom": "2021-02-07 10:10:10 AM",
            "dateTo": "2021-02-07 11:51:00 PM",
            "data": [
                ["periud": "10:10:10 - 14:10:10",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "not"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"]
            ],
            "color": "red"
            ],
            ["name": "Work",
            "amount": [10, 10, 12],
            "dateFrom": "2021-02-06 10:10:10 AM",
            "dateTo": "2021-02-06 11:51:00 PM",
            "data": [
                ["periud": "10:10:10 - 14:10:10",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "not"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"]
            ],
            "color": "red"
            ],
            ["name": "Work",
            "amount": [1, 10, 12],
            "dateFrom": "2021-02-05 10:10:10 AM",
            "dateTo": "2021-02-05 11:51:00 PM",
            "data": [
                ["periud": "10:10:10 - 14:10:10",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "not"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"]
            ],
            "color": "red"
            ],
            ["name": "Work",
            "amount": [7, 45, 50],
            "dateFrom": "2021-02-04 1:10:10 PM",
            "dateTo": "2021-02-04 9:51:00 PM",
            "workName": "work",
            "data": [
                ["periud": "13:10:10 - 14:10:10",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"]
            ],
            "color": "red"
            ],
            ["name": "Work",
            "amount": [9, 12, 12],
            "dateFrom": "2021-02-03 4:10:10 PM",
            "dateTo": "2021-02-03 2:51:00 AM",
            "data": [
                ["periud": "4:10:10 - 10:10:10",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"]
            ],
            "color": "red"
            ],
            ["name": "Work",
            "amount": [4, 40, 50],
            "dateFrom": "2021-02-02 1:10:10 PM",
            "dateTo": "2021-02-02 9:51:00 PM",
            "workName": "work",
            "data": [
                ["periud": "13:10:10 - 14:10:10",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"]
            ],
            "color": "red"
            ],
            ["name": "Work",
            "amount": [10, 10, 12],
            "dateFrom": "2021-02-01 4:10:10 PM",
            "dateTo": "2021-02-01 2:51:00 AM",
            "data": [
                ["periud": "4:10:10 - 10:10:10",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"],
                ["periud": "15:10:10 - 21:51:00",
                 "amount": [7, 40, 50],
                 "workName": "work"]
            ],
            "color": "red"
            ]
            
        ]
        UserDefaults.standard.setValue(testData, forKey: "HistoryData")
    }
}
