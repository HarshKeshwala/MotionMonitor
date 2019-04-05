//
//  ViewController.swift
//  MotionMonitor
//
//  Created by Harsh Keshwala on 2019-04-04.
//  Copyright © 2019 CentennialCollege. All rights reserved.

import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var gyroscopeLabel: UILabel!
    @IBOutlet var accelerometerLabel: UILabel!
    
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    
    private var counter = 0
    var audioPlayer: AVAudioPlayer?
    
    var countLimit = "20"
    
    @IBAction func resetButton(_ sender: UIButton) {
        self.counter = 0
        self.accelerometerLabel.text = String("Steps Taken:\n\n\(self.counter)")
    }
    
    func playSound() {
        do {
            if let fileURL = Bundle.main.path(forResource: "powerup", ofType: "wav") {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                audioPlayer?.play()
            } else {
                print("No file with specified name exists")
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
    }
    
    
    func showInputDialog(title:String? = "Set An Alert!",
                         subtitle:String? = "Please enter steps count limit",
                         actionTitle:String? = "Add",
                         inputPlaceholder:String? = "20",
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.numberPad,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = inputPlaceholder
                    textField.keyboardType = inputKeyboardType
                }
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0]
                    self.countLimit = (textField!.text)!
                    print(self.countLimit)
                }))
        
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showAlert(_ sender: UIButton) {
        self.showInputDialog()
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
                        
                        if ((self.counter) == Int(self.countLimit)) {
                            self.playSound()
                        }
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
