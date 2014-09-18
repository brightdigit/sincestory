//
//  ViewController.swift
//  sincestory
//
//  Created by Leo G Dion on 9/17/14.
//  Copyright (c) 2014 BrightDigit, LLC. All rights reserved.
//

import UIKit
//import Foundation

func readDictionaryFromFile(filePath:String) -> Dictionary<String,AnyObject!>? {
  var anError : NSError?
  

  let data : NSData! = NSData(contentsOfFile: filePath, options: NSDataReadingOptions.DataReadingUncached, error: &anError)
  
  if let theError = anError{
    return nil
  }
  
  let dict : AnyObject! = NSPropertyListSerialization.propertyListWithData(data, options: 0,format: nil, error: &anError)
  
  if dict != nil{
    if let ocDictionary = dict as? NSDictionary {
      var swiftDict : Dictionary<String,AnyObject!> = Dictionary<String,AnyObject!>()
      for key : AnyObject in ocDictionary.allKeys{
        let stringKey : String = key as String
        
        if let keyValue : AnyObject = ocDictionary.valueForKey(stringKey){
          swiftDict[stringKey] = keyValue
        }
      }
      return swiftDict
    } else {
      return nil
    }
  } else if let theError = anError {
    println("Sorry, couldn't read the file \(filePath.lastPathComponent):\n\t"+theError.localizedDescription)
  }
  return nil
}

class ViewController: UIViewController {

  var gmailService:GTLServiceGmail
  var cid_str:String = ""
  var cs_str:String = ""

  
  required init(coder aDecoder: NSCoder) {

    gmailService = GTLServiceGmail()
    
    /*
    let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist")!
    let dict:Dictionary = readDictionaryFromFile(path)!
    let google = dict["Google"]
    println(google)
    if let settings = google as? Dictionary<String, AnyObject!>{
      let client_id = settings["client_id"]
      let client_secret = settings["client_secret"]
      cid_str = client_id as String
      cs_str = client_secret as String
      gmailService.authorizer = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName("sincestory", clientID:cid_str, clientSecret:cs_str, error: nil)
    }
    */
    super.init(coder: aDecoder)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

  }
  /*
  // Creates the auth controller for authorizing access to Google Drive.
  - (GTMOAuth2ViewControllerTouch *)createAuthController
  {
  GTMOAuth2ViewControllerTouch *authController;
  authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile
  clientID:kClientID
  clientSecret:kClientSecret
  keychainItemName:kKeychainItemName
  delegate:self
  finishedSelector:@selector(viewController:finishedWithAuth:error:)];
  return authController;
  }
*/
  
  func createAuthController() -> GTMOAuth2ViewControllerTouch {
    var authController = GTMOAuth2ViewControllerTouch(scope:kGTLAuthScopeGmailReadonly,clientID: cid_str, clientSecret: cs_str, keychainItemName:"sincestory", delegate:self, finishedSelector:"viewController:finishedWithAuth:error:")
    return authController
  }
/*
  // Handle completion of the authorization process, and updates the Drive service
  // with the new credentials.
  - (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
  finishedWithAuth:(GTMOAuth2Authentication *)authResult
  error:(NSError *)error
  {
  if (error != nil)
  {
  [self showAlert:@"Authentication Error" message:error.localizedDescription];
  self.driveService.authorizer = nil;
  }
  else
  {
  self.driveService.authorizer = authResult;
  }
  }
  */
  
  func viewController(viewController:GTMOAuth2ViewControllerTouch,finishedWithAuth authResult:GTMOAuth2Authentication , error:NSError ) {
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func click(sender:AnyObject) {
    self.presentViewController(self.createAuthController(), animated: true, completion: nil)
  }
}

