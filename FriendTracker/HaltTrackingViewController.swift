//
//  HaltTrackingViewController.swift
//  FriendTracker
//
//  Created by Akapo Damilola Francis on 04/02/2017.
//  Copyright © 2017 CottaCush. All rights reserved.
//

import UIKit

class HaltTrackingViewController: UIViewController {

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var buttonPurge: UIButton!
    @IBOutlet weak var buttonStopResume: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        buttonPurge.customize()
        buttonStopResume.customize()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setNavBarTitle("Stop Tracker")
        //self.setNormalTitle("Stop Tracker")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.setNavBarTitle(nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentAlert(sender: UIButton) {
        let alertController = UIAlertController(title: "PASSCODE", message: "Please enter your passcode:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                let trackSession = LocalStorage.getInstance().getDefaultTrackingSession();
                if((field.text)! == trackSession?.random_key){
                    if(self.appDelegate.manager != nil){
                        if(self.appDelegate.manager?.isRunning)!{
                            self.appDelegate.manager?.stoptUpdatingLocation()
                            sender.setTitle("PURGED!", for: .normal)
                            sender.isEnabled = false;
                            sender.setTitle("PURGED!", for: .disabled)
                            self.labelStatus.text = "STATUS: PURGED!";
                            self.buttonStopResume.setTitle("START NEW SESSION", for: .normal)
                        }
                    }
                    if(trackSession != nil){
                        self.appDelegate.ref.child((trackSession?.user_email.normalize())!).child(Keys.LOCATION).setValue(nil);
                        self.appDelegate.ref.child((trackSession?.user_email.normalize())!).child(Keys.TRACKING_STATUS).setValue(false)
                    }
                }else{
                    self.createAlertDialog("Ops!", message: "You cannot purge your session without the right passcode");
                }
            } else {
                // user did not fill field
                self.createAlertDialog("Ops!", message: "You cannot purge your session without the right passcode");
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "PASSCODE"
            textField.keyboardType = .numberPad
            textField.addDoneToKeyboard()
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionPurgeTracking(_ sender: UIButton) {
        self.presentAlert(sender: sender)
    }

    @IBAction func actionStopTracking(_ sender: UIButton) {
        if(sender.title(for: .normal) == "START NEW SESSION"){
            if(appDelegate.manager != nil){
                if(appDelegate.manager?.isRunning)!{
                    appDelegate.manager?.stoptUpdatingLocation()
                }
            }
            self.performSegue(identifier: Segue.segueRestartSession)
        }else{
            labelStatus.text = "STATUS: TRACKING HALTED";
            sender.setTitle("START NEW SESSION", for: .normal)
            if(appDelegate.manager != nil){
                if(appDelegate.manager?.isRunning)!{
                    let trackSession = LocalStorage.getInstance().getDefaultTrackingSession();
                    appDelegate.manager?.stoptUpdatingLocation()
                    if(trackSession != nil){
                        appDelegate.ref.child((trackSession?.user_email.normalize())!).child(Keys.TRACKING_STATUS).setValue(false);
                    }
                    sender.setTitle("START NEW SESSION", for: .normal)
                }
            }
        }
        
        
    }

}
