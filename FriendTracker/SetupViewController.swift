//
//  SetupViewController.swift
//  FriendTracker
//
//  Created by Akapo Damilola Francis on 04/02/2017.
//  Copyright © 2017 CottaCush. All rights reserved.
//

import UIKit
import APScheduledLocationManager
import CoreLocation
import Firebase

class SetupViewController: UIViewController, APScheduledLocationManagerDelegate {

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var trackSession : TrackSession? = nil;
    let localStorage = LocalStorage.getInstance();
    
    @IBOutlet weak var textFieldYourEmailAddress: UITextField!
    @IBOutlet weak var textFieldEmail2: UITextField!
    @IBOutlet weak var textFieldEmail1: UITextField!
    @IBOutlet weak var textFieldEmail3: UITextField!
    @IBOutlet weak var switchDefault: UISwitch!
    @IBOutlet weak var buttonStartTracking: UIButton!
    @IBOutlet weak var labelPassMessage: UILabel!
    @IBOutlet weak var labelPassKey: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        self.buttonStartTracking.customize()
        self.textFieldYourEmailAddress.delegate = self;
        self.textFieldEmail1.delegate = self;
        self.textFieldEmail2.delegate = self;
        self.textFieldEmail3.delegate = self;
        self.labelPassMessage.requiredHeight()
        if(appDelegate.manager != nil){
            if(appDelegate.manager?.isRunning)!{
                self.view.isHidden = true;
                self.performSegue(identifier: Segue.segueInitTracking)
            }
        }else{
            appDelegate.setManager(manager: APScheduledLocationManager(delegate: self));
        }
        setUpDefaultValues()
        // Do any additional setup after loading the view.
    }
    
    func generateRandomNumber() -> String!{
        let digit = arc4random_uniform(9999);
        return "\(digit + 1111)";
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setNavBarTitle("Setup Safety Tracker")
        self.labelPassKey.text = self.generateRandomNumber();
    }
    
    func setUpDefaultValues(){
        self.trackSession = LocalStorage.getInstance().getDefaultTrackingSession();
        if(self.trackSession != nil){
            self.textFieldYourEmailAddress.text = self.trackSession?.user_email.replacingOccurrences(of: "_com", with: ".com");
            let emailFields = [self.textFieldEmail1, self.textFieldEmail2, self.textFieldEmail3];
            for (key, auth) in (self.trackSession?.trackers.enumerated())! {
                emailFields[key]?.text = auth;
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actionStartTracking(_ sender: UIButton) {
        self.validateEmailAddresses();
    }
    
    private func validateEmailAddresses() {
        let your_email = self.textFieldYourEmailAddress.text!
        let email_1 = self.textFieldEmail1.text!
        let email_2 = self.textFieldEmail2.text!
        let email_3 = self.textFieldEmail3.text!
        
        let emails = [email_1, email_2, email_3];
        
        self.trackSession = TrackSession();
        
        if(your_email.isValidEmail()){
            self.trackSession?.user_email = your_email.normalize();
            //trackSession.trackers = [];
            for email in emails {
                if(email.isValidEmail()){
                    if(!(self.trackSession?.trackers.contains(email))!){
                        self.trackSession?.trackers.append(email)
                    }
                }
                
            }
            if(!(self.trackSession?.trackers.isEmpty)!){
                self.trackSession?.is_default = switchDefault.isOn;
                self.trackSession?.random_key = (self.labelPassKey.text)!
                localStorage.persistString(string: self.trackSession?.toJsonString(), key: Keys.TRACK_SESSION)
                LogMinx.logData(string: (trackSession?.toJsonString())!);
                self.startTracking(yourEmail: self.trackSession?.user_email, tEmails: (self.trackSession?.trackers)!, passKey: (self.trackSession?.random_key)!);
            }else{
                self.createAlertDialog("Hello!", message:"You need to enter at least one valid notifiable email address");
            }

        }else{
            self.createAlertDialog("Hello!", message:"You need a valid email address to proceed");
        }
        
    }
    
    func startTracking(yourEmail: String!, tEmails: [String], passKey: String!) {
        if(appDelegate.manager != nil){
            if CLLocationManager.authorizationStatus() == .authorizedAlways {
                self.setAuthedEmails(email: yourEmail, emails: tEmails);
                MailParams.getInstance().sendEmailQuietly(emails: tEmails, passkey: passKey, sender: self.textFieldYourEmailAddress.text!)
                self.appDelegate.ref.child((self.trackSession?.user_email.normalize())!).child(Keys.PASS_KEY).setValue(passKey)
                self.appDelegate.ref.child((self.trackSession?.user_email.normalize())!).child(Keys.TRACKING_STATUS).setValue(true);
                self.appDelegate.ref.child((self.trackSession?.user_email.normalize())!).child(Keys.LOCATION).setValue(nil)
                self.appDelegate.counter = 0;
                self.appDelegate.manager?.startUpdatingLocation(interval: 20, acceptableLocationAccuracy: 50)
                self.performSegue(identifier: Segue.segueInitTracking);
            }else{
                self.appDelegate.manager?.requestAlwaysAuthorization()
                
            }
        }
    }
    
    
    private func setAuthedEmails(email: String, emails: [String]){
        LogMinx.logData(string: "Tried setting authed emails \(email) \(emails)");
        appDelegate.ref.child((email.normalize())).child(Keys.AUTH_EMAILS).setValue(emails);
    }

    func scheduledLocationManager(_ manager: APScheduledLocationManager, didUpdateLocations locations: [CLLocation]) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        let l = locations.first!
        
        LogMinx.logData(string: "Location(\(appDelegate.counter)) || \(l.coordinate.latitude), \(l.coordinate.longitude)");
        
        if((appDelegate.ref) == nil){
            appDelegate.ref = FIRDatabase.database().reference();
        }
        
        let co_od = Coordinates();
        co_od.longitude = "\(l.coordinate.longitude)"
        co_od.latitude = "\(l.coordinate.latitude)"
        appDelegate.ref.child((self.trackSession?.user_email.normalize())!).child(Keys.LOCATION).child("\(appDelegate.counter)").setValue(co_od.toJsonString());
            appDelegate.ref.child((self.trackSession?.user_email.normalize())!).child(Keys.TRACKING_STATUS).setValue(true);
            appDelegate.counter += 1
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didFailWithError error: Error) {
        
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }


}
