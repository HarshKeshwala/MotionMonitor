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
    @IBOutlet var attitudeLabel: UILabel!
    
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: queue) {
                (CMDeviceMotion, NSError) in
                if let motion = CMDeviceMotion {
                    let rotationRate = motion.rotationRate
                    let gravity = motion.gravity
                    let userAcc = motion.userAcceleration
                    let attitude = motion.attitude
                    
                    let gyroscopeText =
                        String(format: "Rotation Rate:\n----------\n" +
                            "x: %+.2f\ny: %+.2f\nz: %+.2f\n",
                               rotationRate.x,rotationRate.y, rotationRate.z)
                    
                    let acceleratorText =
                        String(format: "Acceleration: \n----------\n" +
                            "Gravity x: %+.2f\t\tUser x: %.2f\n" +
                            "Gravity y: %+.2f\t\tUser y: %.2f\n" +
                            "Gravity z: %+.2f\t\tUser z: %.2f\n",
                               gravity.x, userAcc.x, gravity.y,
                               userAcc.y, gravity.z, userAcc.z)
                    
                    let attitudeText =
                        String(format: "Attitude:\n--------\n" +
                            "Roll: %+.2f\nPitch: %+.2f\nYaw:%+.2f\n",
                               attitude.roll, attitude.pitch, attitude.yaw)
                    
                    DispatchQueue.main.async {
                        self.gyroscopeLabel.text = gyroscopeText
                        self.accelerometerLabel.text = acceleratorText
                        self.attitudeLabel.text = attitudeText
                    }
                    
                }
            }
        }
    }
}
