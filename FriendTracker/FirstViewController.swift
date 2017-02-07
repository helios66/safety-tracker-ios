//
//  ViewController.swift
//  FriendTracker
//
//  Created by Akapo Damilola Francis on 02/02/2017.
//  Copyright © 2017 CottaCush. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var labelAgreement: UILabel!
    @IBOutlet weak var buttonSetup: UIButton!
    @IBOutlet weak var switchAgree: UISwitch!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let manager = CLLocationManager();

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(appDelegate.manager != nil){
            if(appDelegate.manager?.isRunning)!{
                self.view.isHidden = true;
                self.performSegue(identifier: Segue.segueIsTracking)
            }
        }else{
            if(LocalStorage.getInstance().getDefaultTrackingSession() != nil){
                self.view.isHidden = true;
                self.performSegue(identifier: Segue.segueSetUp)
            }
        }
        self.labelAgreement.requiredHeight()
        self.buttonSetup.customize()
        manager.delegate = self;
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionStartSetup(_ sender: UIButton) {
        if(switchAgree.isOn){
                manager.requestAlwaysAuthorization()
        }else{
            self.createAlertDialog("Hi", message: "You have to agree with the rubbish above to use the app. :)");
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.authorizedAlways){
            self.performSegue(identifier: Segue.segueSetUp);
        }else{
            //manager.requestAlwaysAuthorization()
        }
    }

}

