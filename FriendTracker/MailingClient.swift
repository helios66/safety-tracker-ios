//
//  Secrets.swift
//  FriendTracker
//
//  Created by Akapo Damilola Francis on 05/02/2017.
//  Copyright © 2017 CottaCush. All rights reserved.
//

import Foundation
import EVReflection

class MailParams {
    var count = 0;
    
    init() {
        self.count = 0;
    }
    
    public static func getInstance() -> MailParams! {
        return MailParams();
    }
    
    func sendEmailQuietly(emails: [String], passkey: String!, sender: String!){
        let message = "<b>Yo Ajala The Traveler</b> <p> Visit <a href='http://safety-tracker.elta.com.ng/'> Safety Tracker <a>  and enter this passkey: <p><b>\((passkey)!)</b><p> along with your email address(which ever you received this email with) and your friend/family/archenemy('s) email address \((emails)) to get an overview of your movement pattern.<p><b>Have a nice life!! </b> If you have issues send a mail to safetytracker10@gmail.com."
        self.mailSender(email: MCOAddress(displayName: "Dear User", mailbox: sender), message: message)
        
        for e in emails{
            let message = "<b>Yo \(e)!<b> <p> This is terrible text formatting but \((sender)!) has requested that you be able to gain access to <i>his/her/it/ze location history</i> if he/she/it/ze gets missing or something.<p> Don't be a stalker. Visit <a href='http://safety-tracker.elta.com.ng/'> Safety Tracker <a>  and enter this passkey: <p><b>\((passkey)!)</b><p> along with your email address(which ever you received this email with) and your friend/family/archenemy('s) email address, also in this message.<p><b>Have a nice life!! </b> If you have issues send a mail to safetytracker10@gmail.com."
            self.mailSender(email: MCOAddress(displayName: "Dear User", mailbox: e), message: message);
        }
        
    }
    
    private func mailSender(email: MCOAddress, message: String!){
        LogMinx.logData(string: "Starting emailing session....")
        let smtpSession = MCOSMTPSession()
        var sender = "";
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            // use swift dictionary as normal
            smtpSession.hostname = dict["S_HOSTNAME"] as! String
            smtpSession.username = dict["S_USERNAME"] as! String
            smtpSession.password = dict["S_PASSWORD"] as! String
            smtpSession.port = UInt32(dict["S_PORT"] as! String)!;
            sender = dict["SENDER"] as! String
        }
        
        
        
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.TLS
//        smtpSession.connectionLogger = {(connectionID, type, data) in
//            if data != nil {
//                if NSString(data: data!, encoding: String.Encoding.utf8.rawValue) != nil{
//                    //NSLog("Connectionlogger: \(string)")
//                }
//            }
//        }
        
        let builder = MCOMessageBuilder()
        builder.header.to = [email];
        builder.header.from = MCOAddress(displayName: sender, mailbox: smtpSession.username)
        if(self.count == 0){
            builder.header.bcc = [MCOAddress(displayName: sender, mailbox: smtpSession.username)]
            self.count+=1;
        }
        builder.header.subject = "Safety Tracker Notice"
        builder.htmlBody = message
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(error)")
            } else {
                NSLog("Successfully sent email!")
            }
        }
    }
    
}


