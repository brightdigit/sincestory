//
//  ViewController.swift
//  sincestory
//
//  Created by Leo G Dion on 9/17/14.
//  Copyright (c) 2014 BrightDigit, LLC. All rights reserved.
//

import UIKit
//import Foundation
/*
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
*/

class ViewController: UIViewController {

  let gmailService:GTLServiceGmail
  let google:Configuration.Google
  var authController:GTMOAuth2ViewControllerTouch?
  /*
  var cid_str:String = ""
  var cs_str:String = ""

  */
  required init(coder aDecoder: NSCoder) {
    google = Configuration.current.google
    gmailService = GTLServiceGmail()
    gmailService.authorizer = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName("sincestory", clientID:google.clientID, clientSecret:google.clientSecret, error: nil)

    super.init(coder: aDecoder)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

  }
  
  func createAuthController() -> GTMOAuth2ViewControllerTouch {
    self.authController = GTMOAuth2ViewControllerTouch(scope:kGTLAuthScopeGmailReadonly,clientID: google.clientID, clientSecret: google.clientSecret, keychainItemName:"sincestory", delegate:self, finishedSelector:"viewController:finishedWithAuth:error:")
    return authController!
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
  //   - (GTLServiceTicket *)executeQuery:(GTLQuery *)query
  //                             delegate:(id)delegate
  //                    didFinishSelector:(SEL)finishedSelector;
  //
  // where finishedSelector has a signature of:
  //
  //   - (void)serviceTicket:(GTLServiceTicket *)ticket
  //      finishedWithObject:(id)object
  //                   error:(NSError *)error;
  */
  func viewController(viewController:GTMOAuth2ViewControllerTouch?,finishedWithAuth authResult:GTMOAuth2Authentication? , error:NSError? ) {
    if error != nil {
      println(error)
      self.gmailService.authorizer = nil
    } else {
      let query = GTLQueryGmail.queryForUsersMessagesList() as GTLQueryProtocol?
      self.gmailService.authorizer = authResult
      self.gmailService.executeQuery(query,delegate:self, didFinishSelector:"serviceTicket:finishedWithObject:error:")
      self.dismissViewControllerAnimated(true, completion: nil)
      
    }
  }
  
  func serviceTicket(ticket: GTLServiceTicket?, finishedWithObject object: AnyObject?, error:NSError?) {
    println(object)
    if error != nil {
      
    } else if let messageResponse = object as GTLGmailListMessagesResponse? {
      println(messageResponse)
    }
    
  }
  //   - (void)serviceTicket:(GTLServiceTicket *)ticket
  //      finishedWithObject:(id)object
  //                   error:(NSError *)error;
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func click(sender:AnyObject) {
    self.presentViewController(self.createAuthController(), animated: true, completion: nil)
    //println("clicked")
  }
}
