//
//  ViewController.swift
//  checkinout
//
//  Created by Joy on 3/15/17.
//  Copyright © 2017 me. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var checkInBtn: UIButton!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var locationManager: CLLocationManager!
    var curLocation: CLLocation!
    var time = 0
    var timer = Timer()
    var start: NSDate!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        determinLoc()
        setupUI()
    }
    
    func setupUI() {
        setupSignBtn()
        setupDate()
    }
    
    func setupDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        self.todayLabel.text = result
    }
    
    func setupSignBtn() {
        if checkedOut() {
            checkInBtn.setTitle("Done for today", for: .normal)
            checkInBtn.alpha = 0.7
            getHours()
        }
        else if checking() {
            checkInBtn.setTitle("Check out", for: .normal)
            checkInBtn.alpha = 1.0
            setuptheTimer()
        }
        else if withIn100ms(){
            checkInBtn.setTitle("Check in", for: .normal)
            checkInBtn.alpha = 1.0
            self.timeLabel.text = "0:00:00"
        }
        else {
            checkInBtn.setTitle("Unable to check in", for: .normal)
            checkInBtn.alpha = 0.7
            getHours()
        }
    }
    
    func getHours() {
        self.timeLabel.text = "0:00:00"
    }
    
    func setuptheTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
        start = NSDate()
        
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
        print("\(self.curLocation.coordinate.latitude)")
        print("\(self.curLocation.coordinate.longitude)")
    }
    
    func checkedOut() -> Bool {
        
        return false
    }
    
    func withIn100ms() -> Bool {
        
        return true
    }

    func checking() -> Bool {
        
        return true
    }

}

