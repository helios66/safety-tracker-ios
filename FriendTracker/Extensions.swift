//
//  Extensions.swift
//  FriendTracker
//
//  Created by Akapo Damilola Francis on 04/02/2017.
//  Copyright © 2017 CottaCush. All rights reserved.
//

/*
 Dumping a shit load of extensions here
 */

import Foundation
import UIKit
import MBProgressHUD


var animateDistance: CGFloat!
extension UIViewController : UITextFieldDelegate {
    
    struct MoveKeyboard {
        static let KEYBOARD_ANIMATION_DURATION : CGFloat = 0.3
        static let MINIMUM_SCROLL_FRACTION : CGFloat = 0.2;
        static let MAXIMUM_SCROLL_FRACTION : CGFloat = 0.8;
        static let PORTRAIT_KEYBOARD_HEIGHT : CGFloat = 216;
        static let LANDSCAPE_KEYBOARD_HEIGHT : CGFloat = 162;
    }
    
    func showNetworkIndicator(status: Bool = true){
        OperationQueue.main.addOperation {
            [weak self] in
            self?.dismissKeyboard()
            UIApplication.shared.isNetworkActivityIndicatorVisible = status;
        }
    }
    
    internal func dismissProgressOverview(){
        self.showNetworkIndicator(status: false);
        if(self.navigationItem.rightBarButtonItems != nil){
            for x in self.navigationItem.rightBarButtonItems! {
                x.isEnabled = true;
            }
        }
        
        if(self.navigationController != nil){
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        }
        
        OperationQueue.main.addOperation {
            [weak self] in
            self?.dismissProgressOverlay(view: self?.view)
        }
    }
    
    internal func showProgressView(message: String){
        self.showNetworkIndicator();
        self.dismissKeyboard()
        if(self.navigationItem.rightBarButtonItems != nil){
            for x in self.navigationItem.rightBarButtonItems! {
                x.isEnabled = false;
            }
        }
        
        if(self.navigationController != nil){
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        self.showProgressOverlay(view: self.view, message: message)
    }
    
    
    
    private func showProgressOverlay(view: UIView!, message:String!){
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true);
        loadingNotification.mode = MBProgressHUDMode.indeterminate;
        //loadingNotification.activityIndicatorColor = Colors.BASE_COLOR;
        loadingNotification.backgroundView.backgroundColor = UIColor( red: 0/255, green: 0/255, blue:0/255, alpha: 0.1 );
        loadingNotification.bezelView.backgroundColor = UIColor( red: 255/255, green: 255/255, blue:255/255, alpha: 1.0 );
        loadingNotification.label.text = "Please wait...";
        loadingNotification.detailsLabel.text = message;
    }
    
    public func dismissProgressOverlay(view: UIView!){
        MBProgressHUD.hide(for: view, animated: true);
    }
    
    
    
    
    func loadImageNoew(imageString: String!) -> UIImage? {
        return UIImage(named: imageString);
    }
    
    func performSegue(identifier: String!){
        OperationQueue.main.addOperation {
            [weak self] in
            self?.performSegue(withIdentifier: identifier, sender: self);
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addDoneToKeyboard();
        self.hideKeyboardWhenTappedAround();
        
        var viewFrame : CGRect = self.view.frame
        animateDistance = calculateAnimateDistance(textField: textField);
        viewFrame.origin.y -= animateDistance;
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(TimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        
        self.view.frame = viewFrame
        
        UIView.commitAnimations()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y += animateDistance;
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        UIView.setAnimationDuration(TimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        
        self.view.frame = viewFrame
        
        UIView.commitAnimations()
    }
    
    
    func calculateAnimateDistance(textField: UITextField!) -> CGFloat!{
        var animateDistance: CGFloat!
        let textFieldRect : CGRect = self.view.window!.convert(textField.bounds, from: textField)
        let viewRect : CGRect = self.view.window!.convert(self.view.bounds, from: self.view)
        
        let midline : CGFloat = textFieldRect.origin.y + 0.5 * textFieldRect.size.height
        let numerator : CGFloat = midline - viewRect.origin.y - MoveKeyboard.MINIMUM_SCROLL_FRACTION * viewRect.size.height
        let denominator : CGFloat = (MoveKeyboard.MAXIMUM_SCROLL_FRACTION - MoveKeyboard.MINIMUM_SCROLL_FRACTION) * viewRect.size.height
        var heightFraction : CGFloat = numerator / denominator
        
        if heightFraction < 0.0 {
            heightFraction = 0.0
        } else if heightFraction > 1.0 {
            heightFraction = 1.0
        }
        
        let orientation : UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
        if (orientation == UIInterfaceOrientation.portrait || orientation == UIInterfaceOrientation.portraitUpsideDown) {
            animateDistance = floor(MoveKeyboard.PORTRAIT_KEYBOARD_HEIGHT * heightFraction)
        } else {
            animateDistance = floor(MoveKeyboard.LANDSCAPE_KEYBOARD_HEIGHT * heightFraction)
        }
        
        return animateDistance;
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func setNavBarTitle(_ title: String?){
        self.navigationController?.navigationBar.topItem?.title = title;
    }
    
    func setNormalTitle(_ title: String!){
        self.title = title;
    }
    
    func setUpHomeNavBarItem(){
        let goHome = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.goHome(_:)));
        self.navigationItem.rightBarButtonItem = goHome;
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white;
    }
    
    func goHome(_ tabItem: UIBarButtonItem){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let home = storyboard.instantiateViewController(withIdentifier: "homeNavBarController");
        self.present(home, animated: true, completion: nil);
    }
    
    
    func goHome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let home = storyboard.instantiateViewController(withIdentifier: "homeNavBarController");
        self.present(home, animated: true, completion: nil);
    }
    
    func generateBackItem(text: String?) -> UIBarButtonItem {
        let backItem = UIBarButtonItem()
        backItem.title = text ?? "Back"
        return backItem;
    }
    
    func createAlertDialog(_ title: String! = "Oops!", message: String! = "Network error!.", ltrActions: [UIAlertAction]! = []) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        
        if(ltrActions.count == 0){
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil);
            alertController.addAction(defaultAction);
        }else{
            for x in ltrActions{
                alertController.addAction(x as UIAlertAction);
            }
        }
        
        self.present(alertController, animated: true, completion: nil);
    }
    
    func creatAlertAction(_ title: String! = "Ok", style: UIAlertActionStyle = .default, clicked: ((_ action: UIAlertAction) -> Void)?) -> UIAlertAction! {
        return UIAlertAction(title: title, style: style, handler: clicked);
    }
    
    func createActionSheet(_ message: String! = "Select one", ltrActions: [UIAlertAction]! = []){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.actionSheet);
        
        if(ltrActions.count == 0){
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil);
            alertController.addAction(defaultAction);
        }else{
            for x in ltrActions{
                alertController.addAction(x as UIAlertAction);
            }
        }
        self.present(alertController, animated: true, completion: nil);
    }
    
    func logout() {
        
    }
    
    func clearAccessToken() {
        
    }
    
    func setVersion(label: UILabel!){
        label.text = "\(UIApplication.shared.versionBuild())";
        label.requiredHeight();
    }
    
    func isDebug() -> Bool{
        #if DEBUG
            return true;
        #else
            return false
        #endif
    }
    
}

extension UIApplication {
    func applicationVersion() -> String {
        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    func applicationBuild() -> String {
        
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    func versionBuild() -> String {
        
        let version = self.applicationVersion()
        let build = self.applicationBuild()
        
        return "v\(version)(\(build))"
    }
    
}

extension UITableViewCell {
    
    func loadImageNow(imageString: String!) -> UIImage? {
        return UIImage(named: imageString);
    }
    
}


extension UITextField {
    
    func clearText() {
        self.text = "";
    }
    
    func addDoneToKeyboard() {
        let keyboardDoneButtonView = UIToolbar();
        keyboardDoneButtonView.sizeToFit();
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target:self, action:nil);
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(UITextField.doneClicked(narButton:)))
        doneButton.tintColor = UIColor.tint
        keyboardDoneButtonView.setItems([flexible, doneButton], animated: true);
        self.inputAccessoryView = keyboardDoneButtonView;
    }
    
    
    func doneClicked(narButton: UIBarButtonItem){
        self.superview?.endEditing(true);
    }
    
    
}

extension UIView {
    public func addShadow(){
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 4.3
        self.layer.cornerRadius = 4.3
    }
}

extension UILabel{
    
    func requiredHeight(){
        let label: UILabel = self;
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
    }
}

extension UIButton{
    func customize(){
        self.layer.cornerRadius = 4.3
    }
}

extension UICollectionViewCell{
    func customize(){
        self.layer.cornerRadius = 4.3
    }
}

extension String{
    func isValidEmail() -> Bool{
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self);
    }
    
    func isValidUrl() -> Bool {
        let urlFormat = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlPredicate = NSPredicate(format:"SELF MATCHES %@", urlFormat)
        return urlPredicate.evaluate(with: self);
    }
    
    func normalize() -> String! {
        return self.replacingOccurrences(of: ".", with: "_");
    }
    
    
    func trim() -> String! {
        return self.trimmingCharacters(in: CharacterSet.whitespaces);
    }
    
}

extension NSDictionary {
    
    func toJson() -> String?{
        let invalidJson: String? = nil
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
}

extension UIColor {
    class var tint: UIColor {
        return UIColor(red: 0.0, green: 56.0 / 255.0, blue: 131.0 / 255.0, alpha: 1.0)
    }
    
    class var abgNegative: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 130.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}

extension Int {
    init(_ range: Range<Int> ) {
        let delta = range.lowerBound < 0 ? abs(range.lowerBound) : 0
        let min = UInt32(range.lowerBound + delta)
        let max = UInt32(range.upperBound   + delta)
        self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }
}

