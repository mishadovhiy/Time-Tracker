//
//  HistoryVC.swift
//  Time Tracker
//
//  Created by Mikhailo Dovhyi on 11.02.2021.
//

import UIKit

class HistoryVC: superVC, UIGestureRecognizerDelegate {
    
    var tableData: [[String: Any]] = []
    var dataHolder: [[String: Any]] {
        get {
            let r = UserDefaults.standard.value(forKey: "HistoryData") as? [[String: Any]] ?? []
            return r
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "HistoryData")
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var timeRunningAt: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let desctiprion = tableData
        print("vc:", desctiprion)
        
        tableData = dataHolder
        for i in 0..<dataHolder.count {
            tableData[i]["data"] = []
            if timeRunningAt != nil {
                if i == timeRunningAt {
                    tableData[i]["data"] = dataHolder[i]["data"]
                }
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    var showWorkNameInDescription = false
    
    @objc func sectionSelected(_ sender: UITapGestureRecognizer) {
        if let name = sender.name {
            if let section = Int(name) {
                tableData[section]["data"] = (tableData[section]["data"] as? [[String: Any]] ?? []).count == 0 ? dataHolder[section]["data"] : []

                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: section), with: .none)
                }
            }
        }
    }

}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableData[section]["data"] as? [[String: Any]] ?? []).count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! historyCell
            let data = tableData[indexPath.section]
            let dateFrom = stringToDate(from: data["dateFrom"] as? String ?? "")
            let dateTo = stringToDate(from: data["dateTo"] as? String ?? "")
            let startHour = dateFrom.hour ?? 0
            let amount = (data["amount"] as? [Int] ?? [])
            
            
            let color = UIColor.systemGreen
            let superFrame = cell.timeProgressView.superview?.frame ?? CGRect.zero
            let progressFrame = cell.timeProgressView.frame
            let minX = superFrame.width / 24.0 * CGFloat(startHour)
            let width = superFrame.width / 24.0 * CGFloat(amount[0])
            cell.fromLabel.translatesAutoresizingMaskIntoConstraints = true
            cell.toLabel.translatesAutoresizingMaskIntoConstraints = true
            cell.timeProgressView.translatesAutoresizingMaskIntoConstraints = true
            cell.timeProgressView.superview?.superview?.layer.cornerRadius = 6
            cell.timeProgressView.superview?.superview?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.timeProgressView.superview?.superview?.layer.masksToBounds = true
            cell.timeProgressView.frame = CGRect(x: minX, y: progressFrame.minY, width: width == 0.0 ? 10 : width, height: progressFrame.height)
            cell.timeProgressView.backgroundColor = color
            cell.timeProgressView.layer.cornerRadius = 4
            let lebalFrame = cell.toLabel.layer.frame
            if minX + width > superFrame.width {
                let secondView = UIView(frame: CGRect(x: 0, y: progressFrame.minY, width: (minX + width) - superFrame.width, height: progressFrame.height))
                secondView.layer.cornerRadius = 4
                secondView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                secondView.backgroundColor = color
                cell.timeProgressView.superview?.addSubview(secondView)
                if lebalFrame.width + minX >= superFrame.width {
                    cell.toLabel.alpha = 0
                } else {
                    cell.toLabel.layer.frame = CGRect(x: (minX + width) - superFrame.width, y: lebalFrame.minY, width: lebalFrame.width, height: lebalFrame.height)
                }
            } else {
                if ((minX + width) + lebalFrame.width) > superFrame.width {
                    cell.toLabel.layer.frame = CGRect(x: cell.timeProgressView.frame.maxX - lebalFrame.width - 2, y: lebalFrame.minY, width: lebalFrame.width, height: lebalFrame.height)
                    cell.toLabel.textAlignment = .right
                }
                if width < lebalFrame.width {
                    print("bigger at", indexPath.row)
                    cell.fromLabel.text = "\(makeTwo(int: dateFrom.hour ?? 0)):\(makeTwo(int: dateFrom.minute ?? 0)) - \(makeTwo(int: dateTo.hour ?? 0)):\(makeTwo(int: dateTo.minute ?? 0))"
                    cell.toLabel.text = ""
                    let fr = cell.fromLabel.frame
                    print(superFrame.width - fr.width)
                    cell.fromLabel.frame = CGRect(x: -100, y: fr.minY, width: 100, height: fr.height)
                    cell.fromLabel.textAlignment = .right
                }
            }
            
            cell.fromLabel.text = "\(makeTwo(int: dateFrom.hour ?? 0)):\(makeTwo(int: dateFrom.minute ?? 0))"
            cell.toLabel.text = "\(makeTwo(int: dateTo.hour ?? 0)):\(makeTwo(int: dateTo.minute ?? 0))"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyDescriptionCell") as! historyDescriptionCell
            let desctiprion = tableData[indexPath.section]["data"] as? [[String: Any]] ?? []
            if indexPath.row == 1 {
                showWorkNameInDescription = false
                let workName = desctiprion[indexPath.row-1]["workName"] as? String
                for i in 0..<desctiprion.count {
                    if desctiprion[i]["workName"] as? String != workName {
                        showWorkNameInDescription = true
                    }
                }
            }
            cell.periodLabel.text = desctiprion[indexPath.row-1]["periud"] as? String ?? "no value"
            let amount = desctiprion[indexPath.row-1]["amount"] as? [Int] ?? []
            cell.amountLabel.text = "\(makeTwo(int: amount[0])):\(makeTwo(int: amount[1])):\(makeTwo(int: amount[2]))"
            cell.workNameLabel.text = showWorkNameInDescription ? desctiprion[indexPath.row-1]["workName"] as? String : ""
            
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.separatorInset.left = tableView.frame.width / 2
            cell.separatorInset.right = tableView.frame.width / 2
        } else {
            cell.separatorInset.left = 13
            cell.separatorInset.right = 13
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let data = tableData[section]
        let dateFrom = stringToDate(from: data["dateFrom"] as? String ?? "")
        let amount = (data["amount"] as? [Int] ?? [])
        let leftSideWidth = 55
        let textColor = UIColor(named: "textColor")
        
        let mainView = UIView(frame: .zero)
        mainView.backgroundColor = UIColor(named: "backgroundColor")
        let view = UIView(frame: CGRect(x: 10, y: 10, width: tableView.frame.width - 20, height: 45))
        view.layer.cornerRadius = 6
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let viewFrame = view.frame
        mainView.addSubview(view)
        view.backgroundColor = UIColor(named: "greyColor")
        let dayLabel = UILabel(frame: CGRect(x: 0, y: 4, width: leftSideWidth, height: 24))
        dayLabel.text = "\(dateFrom.day ?? 0)"
        dayLabel.textColor = textColor
        dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        dayLabel.textAlignment = .center
        view.addSubview(dayLabel)
        let monthLabel = UILabel(frame: CGRect(x: 0, y: 25, width: leftSideWidth, height: 10))
        monthLabel.text = "\(dateFrom.month ?? 0), \(dateFrom.year ?? 0)"
        monthLabel.textColor = textColor
        monthLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        monthLabel.textAlignment = .center
        view.addSubview(monthLabel)
        let separetoreView = UIView(frame: CGRect(x: leftSideWidth+1, y: 7, width: 1, height: 30))
        separetoreView.backgroundColor = textColor
        view.addSubview(separetoreView)
        
        let amountWidth = (Int(viewFrame.width) - leftSideWidth) / 2
        let rightView = UIView(frame: CGRect(x: leftSideWidth + 13, y: 12, width: amountWidth, height: 35))
        view.addSubview(rightView)
        let amountStack = UIStackView()
        amountStack.spacing = 1
        amountStack.alignment = .firstBaseline
        amountStack.distribution = .equalSpacing
        amountStack.axis = .horizontal
        rightView.addSubview(amountStack)
        amountStack.translatesAutoresizingMaskIntoConstraints = false
        
        let hourLabel = UILabel()
        hourLabel.text = "\(makeTwo(int: amount[0]))"
        hourLabel.font = .systemFont(ofSize: 18, weight: .medium)
        let hourI = UILabel()
        hourI.text = "h,"
        hourI.font = .systemFont(ofSize: 10, weight: .medium)
        let minuteLabel = UILabel()
        minuteLabel.text = "\(makeTwo(int: amount[1]))"
        minuteLabel.font = .systemFont(ofSize: 18, weight: .medium)
        let minuteI = UILabel()
        minuteI.text = "m,"
        minuteI.font = .systemFont(ofSize: 10, weight: .medium)
        let secondsLabel = UILabel()
        secondsLabel.text = "\(makeTwo(int: amount[2]))s"
        secondsLabel.font = .systemFont(ofSize: 10, weight: .medium)
        let amountStackLabels: [UILabel] = [hourLabel, hourI, minuteLabel, minuteI, secondsLabel]
        for label in amountStackLabels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.adjustsFontSizeToFitWidth = true
            label.textColor = textColor
            amountStack.addArrangedSubview(label)
        }
        let workLabel = UILabel(frame: CGRect(x: Int(viewFrame.width) - amountWidth, y: 0, width: Int(amountWidth) - 7, height: 45))
        workLabel.textAlignment = .right
        workLabel.textColor = textColor
        workLabel.text = data["name"] as? String
        workLabel.font = .systemFont(ofSize: 14, weight: .medium)
        workLabel.alpha = 0.3
        view.addSubview(workLabel)
        
        let selectGesture = UITapGestureRecognizer(target: self, action: #selector(sectionSelected(_:)))
        selectGesture.name = "\(section)"
        selectGesture.delegate = self
        mainView.addGestureRecognizer(selectGesture)
        
        return mainView
        
    }
    
    
}

class historyCell: UITableViewCell {
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var timeProgressView: UIView!

}

class historyDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var workNameLabel: UILabel!
    
}
