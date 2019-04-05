//
//  ViewController.swift
//  MotionMonitor
//
//  Created by Harsh Keshwala on 2019-04-04.
//  Copyright © 2019 CentennialCollege. All rights reserved.

import UIKit
import CoreMotion

class ViewController: UIViewController {


    @IBOutlet var gyroscopeLabel: UILabel!
    @IBOutlet var accelerometerLabel: UILabel!
    
    
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    
    private var counter = 0
    
    @IBAction func resetButton(_ sender: UIButton) {
        self.counter = 0
        self.accelerometerLabel.text = String("Steps Taken:\n\n\(self.counter)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: queue) {
                (CMDeviceMotion, NSError) in
                if let motion = CMDeviceMotion {
                    let userAcc = motion.userAcceleration

                    if ((userAcc.x > 1) || (userAcc.y > 1) || (userAcc.z > 1)) {
                        print("Step Taken")
                        self.counter = self.counter + 1
                    }
                    
                    DispatchQueue.main.async {
                        self.gyroscopeLabel.text = "Step Counter"
                        self.accelerometerLabel.text = String("Steps Taken:\n\n\(self.counter)")
                    }
                    
                    
                }
            }
        }
    }
}
