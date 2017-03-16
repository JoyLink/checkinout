//
//  ViewController.swift
//  checkinout
//
//  Created by Joy on 3/15/17.
//  Copyright © 2017 me. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var checkInBtn: UIButton!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var controller: UITableView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    var locationManager: CLLocationManager!
    var curLocation: CLLocation = InfowayLocation
    var time = 0
    var timer = Timer()
    var start: NSDate!
    var dayTimers:[DayRecord] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.controller.delegate = self
        self.controller.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        determinLoc()
        setupUI()
    }
    
    func setupUI() {
        setupSignBtn()
        setupDate()
        if checkInBtn.alpha == 0.7 {
            checkInBtn.isUserInteractionEnabled = false
        } else {
            checkInBtn.isUserInteractionEnabled = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        cell.configCell(dayRecord: self.dayTimers[indexPath.row])
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getDayTimers()
        return self.dayTimers.count
    }
    
    func setupDate() {
        let result = getTodayDate()
        self.todayLabel.text = result
    }
    
    func getTodayDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }
    
    func setupSignBtn() {
        if checkedOut() {
            checkInBtn.setTitle(donefortoday, for: .normal)
            checkInBtn.alpha = 0.7
            checkInBtn.isUserInteractionEnabled = false
        }
        else if checking() {
            checkInBtn.setTitle(checkout, for: .normal)
            checkInBtn.alpha = 1.0
            checkInBtn.isUserInteractionEnabled = true
            setuptheTimer()
        }
        else if withIn100ms(){
            checkInBtn.setTitle(checkin, for: .normal)
            checkInBtn.alpha = 1.0
            checkInBtn.isUserInteractionEnabled = true
            self.timeLabel.text = "00:00:00"
        }
        else {
            checkInBtn.setTitle(unabletocheck, for: .normal)
            checkInBtn.alpha = 0.7
            checkInBtn.isUserInteractionEnabled = false
        }
    }
    
    
    func setuptheTimer() {
        if self.timer.isValid == false{
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
        }
        
    }
    
    
    func action() {
        let end = NSDate()
        let timeInterval: Double = end.timeIntervalSince(start as Date); // <<<<< Difference in seconds (double)
        var (H, M, S) = secondsToHoursMinutesSeconds(seconds: Int(timeInterval))
        self.timeLabel.text = ("\(H):\(M):\(S)")
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func determinLoc() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.curLocation = locations[0] as CLLocation
        self.longtitudeLabel.text = "\(self.curLocation.coordinate.longitude)"
        self.latitudeLabel.text = "\(self.curLocation.coordinate.latitude)"
        setupUI()
    }
    
    func checkedOut() -> Bool {
        getDayTimers()
        for record in dayTimers {
            if record.date == getTodayDate() {
                var (H, M, S) = secondsToHoursMinutesSeconds(seconds: Int(record.hours))
                self.timeLabel.text = ("\(H):\(M):\(S)")
                return true
            }
        }
        return false
    }
    
    func withIn100ms() -> Bool {
        
        return true
        
//        if let distanceInMeters = curLocation.distance(from: InfowayLocation) as? Double {
//            if distanceInMeters <= 100.0 {
//                return true
//            }
//        }
//        
//        return false
    }

    func checking() -> Bool {
        if self.timer.isValid{
            return true
        }
        return false
    }
    
    func doCheckin() {
        start = NSDate()
        setuptheTimer()
    }
    
    func doCheckout() {
        let end = NSDate()
        let timeInterval: Double = end.timeIntervalSince(start as Date);
        let dayTime = DayTimer(date: getTodayDate(), time: Int(timeInterval))
        dayTime.save()
        self.timer.invalidate()
    }

    @IBAction func CheckBtnPressed(_ sender: Any) {
        
        if let checkText = checkInBtn.titleLabel?.text {
            if checkText == checkin {
                doCheckin()
            } else if checkText == checkout {
                let alert = UIAlertController(title: "Warning!", message: "Are you sure to check out? You can't re-check in today!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
                    switch action.style{
                    case .default:
                        self.doCheckout()
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }
                }))
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
            }
        }
    }
    
    func getDayTimers() {
        do {
            dayTimers = try context.fetch(DayRecord.fetchRequest())
        } catch {
            print("Ooops")
        }
    }
}

