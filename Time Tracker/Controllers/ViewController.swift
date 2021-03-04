//
//  ViewController.swift
//  Time Tracker
//
//  Created by Mikhailo Dovhyi on 26.11.2020.
//

import UIKit
let DateFormat = "yyyy-MM-dd HH:mm:ss"
//stop timer


class ViewController: superVC {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: StartButton!
    @IBOutlet weak var stopButton: UIButton!
    let defaults = UserDefaults.standard
    let textField: UITextField = UITextField(frame: .zero)
    var vcFrame = CGRect.zero
    var timer: Timer?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  let superStart = "2021-02-12 1:10:10 PM"
        let amount = [4, 42, 0]
        let startPressed = "2021-02-12 1:10:10 PM"
        let amountSeconds = (amount[0] * 3600) + (amount[1] * 60) + amount[2]
        let resultSeconds = (workLimit * 3600) - amountSeconds
        let start = dateFrom(sting: startPressed)
        var startDate = start ?? Date()
        startDate.addTimeInterval(TimeInterval(resultSeconds))
        let dateTo = startDate
        let resultAmount = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: start ?? Date(), to: dateTo)
        print([resultAmount.hour ?? 0, resultAmount.minute ?? 0, resultAmount.second ?? 0], "result amount")
        print(dateTo, "result dateTo")
        
        createTestData()
        updateUI()
        stopButton.alpha = 0
        if let timerRunning = startPressedDate {
            if let startDate = dateFrom(sting: timerRunning) {
                self.startButton.tag = 1
                print("timer load")
                justLoaded = true
                updateTimer(was: startDate)
            }
        } else {
            if stopStartDefference != [] {
                DispatchQueue.main.async {
                    self.stopButton.alpha = 1
                    self.startButton.setTitle("\(self.makeTwo(int: self.stopStartDefference[0])) : \(self.makeTwo(int: self.stopStartDefference[1])) : \(self.makeTwo(int: self.stopStartDefference[2]))", for: .normal)
                }
            }
        }
    }
    
    
    func updateUI() {
        vcFrame = self.view.frame
        titleLabel.isUserInteractionEnabled = true
        let labelGesture = UITapGestureRecognizer(target: self, action: #selector(titlePressed(_:)))
        titleLabel.addGestureRecognizer(labelGesture)
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(testFieldEditing), for: .editingChanged)
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        DispatchQueue.main.async {
            self.textField.backgroundColor = UIColor.white
            self.view.addSubview(self.textField)
        }
    }
    
    
    
    
    
    
    
    
    var justLoaded = false
    func updateTimer(was: Date) {
        print("starting actual timer")

        let hoursToSeconds = stopStartDefference != [] ? stopStartDefference[0] * 3600 : 0
        let minutesToSeconds = stopStartDefference != [] ? stopStartDefference[1] * 60 : 0
        let seconds = hoursToSeconds + minutesToSeconds + (stopStartDefference != [] ? stopStartDefference[2] : 0)
        print("starting timer was:", was)
        print("starting timer difference:", seconds)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (a) in
            let d =  self.differenceFromNow(startDate: was, difference: seconds)
            if d.day + d.month + d.year == 0 {
                if d.hour < self.workLimit {
                    self.justLoaded = false
                    let hour = d.hour != 0 ? "\(self.makeTwo(int: d.hour)) :" : "00 :"
                    let minute = d.minute != 0 ? "\(self.makeTwo(int: d.minute)) :" : "00 :"
                    let seconds = d.second != 0 ? "\(self.makeTwo(int: d.second))" : "00"
                    let title = "\(hour) \(minute) \(seconds)"
                    if self.stopTimers == true {
                        print("timer: stopTimers")
                        self.stopStartDefference = [d.hour, d.minute, d.second]
                        let diffromLast = self.differenceFromNow(startDate: was)
                        self.pauseSave(diferrenceFromLastDate: diffromLast)
                        self.startPressedDate = nil
                        a.invalidate()
                    }
                    DispatchQueue.main.async {
                        self.startButton.setTitle(title, for: .normal)
                    }
                } else {
                    print("u v riched hour limit")
                    if !self.justLoaded {
                        //max date
                        self.pauseSave(diferrenceFromLastDate: d)
                        self.startPressedDate = nil
                    } else {
                        self.pauseSave(diferrenceFromLastDate: d)
                        self.startPressedDate = nil
                    }
                    self.newTimerDate = nil
                    self.stopStartDefference = []
                    a.invalidate()
                }
            } else {
                print("u v riched day limit")
                if !self.justLoaded {
                    self.pauseSave(diferrenceFromLastDate: d)
                    self.startPressedDate = nil
                } else {
                    self.pauseSave(diferrenceFromLastDate: d)
                    self.startPressedDate = nil
                }
                self.stopStartDefference = []
                self.newTimerDate = nil
                a.invalidate()
            }
        }
    }
    
    
    var stopTimers = false
    func pauseSave(diferrenceFromLastDate: DateStruct) {
        var title = ""
        DispatchQueue.main.async {
            title = self.titleLabel.text ?? "Unknown"
        }
        let now = Date()
        let dateNow = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        //print(dateNow.year, dateNow.month, dateNow.day, dateNow.hour, dateNow.minute, dateNow.second, "pouse pressed")
        let stopPressedString: String = "\(makeTwo(int: dateNow.hour ?? 0)):\(makeTwo(int: dateNow.minute ?? 0)):\(makeTwo(int: dateNow.second ?? 0))"
        var allData = UserDefaults.standard.value(forKey: "HistoryData") as? [[String: Any]] ?? []
       // print("newTimerDatenewTimerDate", newTimerDate)
        
        let newTD = stringToDate(from: newTimerDate ?? "")
        let newTDComp = [newTD.year ?? 0, newTD.month ?? 0, newTD.day ?? 0] // test start timer yeasterday - ctop today - chould append to existing
        
        var startPressedHourse = ""
        if let from = startPressedDate {
            let formater = DateFormatter()
            formater.dateFormat = DateFormat
            let pressedHours = formater.date(from: from)
            if let date = pressedHours {
                let component = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
                startPressedHourse = "\(makeTwo(int: component.hour ?? 0)):\(makeTwo(int: component.minute ?? 0)):\(makeTwo(int: component.second ?? 0))"
            }
        }
        var found = false
        for i in 0..<allData.count {
            let datFrom = stringToDate(from: allData[i]["dateFrom"] as? String ?? "")
            let dateCompFrom = [datFrom.year ?? 0, datFrom.month ?? 0, datFrom.day ?? 0]
            print("dateCompFrom:", dateCompFrom)
            print("newTDComp:", newTDComp)
            if dateCompFrom == newTDComp {
                found = true
                var data = allData[i]["data"] as? [[String: Any]] ?? []
                print(data, "stop: found")
                data.insert([
                    "periud": "\(startPressedHourse) - \(stopPressedString)",
                    "amount": [diferrenceFromLastDate.hour, diferrenceFromLastDate.minute, diferrenceFromLastDate.second],
                    "workName": title
                ], at: 0)
                allData[i]["amount"] = stopStartDefference
                allData[i]["dateTo"] = nowToString()
                allData[i]["data"] = data
                UserDefaults.standard.setValue(allData, forKey: "HistoryData")
                print("inserted", data)
                print("alldata:", allData)
                self.startPressedDate = nil
                return
            }
        }
        if !found {
            print("stop: not found")
            let resultt: [String: Any] = [
                "name": title,
                 "amount": stopStartDefference,
                 "dateFrom" : newTimerDate ?? "Error!",
                 "dateTo": nowToString(),
                 "data": [[
                    "periud": "\(startPressedHourse) - \(stopPressedString)",
                    "amount": stopStartDefference
                 ]],
                 "color": "UIColor.red"
            ]
            allData.insert(resultt, at: 0)
            UserDefaults.standard.setValue(allData, forKey: "HistoryData")
            self.startPressedDate = nil
        }
        print(allData, "STOP ALL DATA")
    }
    
    
    @IBAction func stopTimerPressed(_ sender: UIButton) {
        self.stopStartDefference = []
        startPressedDate = nil
        stopTimers = true
        newTimerDate = nil
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.6) {
                self.stopButton.alpha = 0
            } completion: { (_) in
                self.startButton.setTitle("Start", for: .normal)
            }
        }
    }
    
    
    
    
    @IBAction func startPressed(_ sender: StartButton) {
        let now = Date()
        let dateNow = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        print(dateNow.year, dateNow.month, dateNow.day, dateNow.hour, dateNow.minute, dateNow.second, "startPressed")
        
        if sender.tag == 0 {
            DispatchQueue.main.async {
                self.startButton.setTitle(self.stopStartDefference.count == 0 ? "Start" : "Resume", for: .normal)
                UIView.animate(withDuration: 0.6) {
                    self.stopButton.alpha = 0
                } completion: { (_) in
                    
                }
            }
            stopTimers = false
            sender.tag = 1
            let now = nowToString()
            
            if let _ = newTimerDate {
                if let dateFromString = dateFrom(sting: now) {
                    startPressedDate = now
                    print("keep running timer")
                    updateTimer(was: dateFromString)
                }
            } else {
                print("new timer")
                var found = false
                let alldata = UserDefaults.standard.value(forKey: "HistoryData") as? [[String: Any]] ?? []
                let datNow = stringToDate(from: nowToString())
                let dateNowCompFrom = [datNow.year ?? 0, datNow.month ?? 0, datNow.day ?? 0]
                for i in 0..<alldata.count {
                    let datFrom = stringToDate(from: alldata[i]["dateFrom"] as? String ?? "")
                    let dateCompFrom = [datFrom.year ?? 0, datFrom.month ?? 0, datFrom.day ?? 0]
                    if dateNowCompFrom == dateCompFrom {
                        print("new timer: timer found")
                        let foundDate = alldata[i]["dateFrom"] as? String ?? ""
                        startPressedDate = now
                        self.stopStartDefference = alldata[i]["amount"] as? [Int] ?? []
                        found = true
                        self.newTimerDate = foundDate
                        if let was = dateFrom(sting: now) {
                            updateTimer(was: was)
                            return
                        }
                    }
                }
                if !found {
                    print("new timer: starting a new timer")
                    startPressedDate = now
                    self.newTimerDate = now
                    if let nowDate = dateFrom(sting: now) {
                        updateTimer(was: nowDate)
                    }
                }
                
                
            }
        } else {
            if sender.tag == 1 {
                sender.tag = 0
                DispatchQueue.main.async {
                    self.startButton.setTitle("Stop", for: .normal)
                    UIView.animate(withDuration: 0.6) {
                        self.stopButton.alpha = 1
                    }
                }
                
                self.stopTimers = true
            }
        }
    }
    
    
    
    var mainTitleDefaults: String {
        set{
            let was = defaults.value(forKey: "UserDefaults_MainTitle") as? String ?? "Work"
            let result = newValue != "" ? newValue : was
            print("mainTitle = ", result)
            defaults.set(result, forKey: "UserDefaults_MainTitle")
            DispatchQueue.main.async {
                self.titleLabel.text = result
            }
        }
        get{
            return defaults.value(forKey: "UserDefaults_MainTitle") as? String ?? "Work"
        }
    }

    @objc func titlePressed(_ gesture: UITapGestureRecognizer) {
        textField.becomeFirstResponder()
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        DispatchQueue.main.async {
            self.textField.text = self.titleLabel.text
        }
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let frame = self.view.frame
            let newFrame = CGRect(x: 0, y: -keyboardHeight / 2, width: frame.width, height: frame.height)
            
            DispatchQueue.main.async {
                self.view.superview?.backgroundColor = self.view.backgroundColor
                UIView.animate(withDuration: 0.4) {
                    self.view.frame = newFrame
                } completion: { (_) in
                    self.startButton.isEnabled = true
                }
            }
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.view.frame = self.vcFrame
            } completion: { (_) in
                self.startButton.isEnabled = true
                if self.textField.text == "" {
                    UIView.animate(withDuration: 0.2) {
                        self.titleLabel.textColor = .black
                    }
                }
            }
            
        }
    }
    
    @objc func testFieldEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.mainTitleDefaults = textField.text ?? ""
            self.titleLabel.textColor = textField.text != "" ? .black : .lightGray
        }
        
    }
    
}

struct DateStruct {
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
    let minute: Int
    let second: Int
}

