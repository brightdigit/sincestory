//
//  ViewController.swift
//  SinceStory
//
//  Created by Leo G Dion on 9/11/14.
//  Copyright (c) 2014 BrightDigit, LLC. All rights reserved.
//

import UIKit

let clientId = ""

class ViewController: UIViewController, GPPSignInDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    var signIn = GPPSignIn.sharedInstance()
    signIn.shouldFetchGooglePlusUser = true
    signIn.shouldFetchGoogleUserEmail = true
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email

    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = clientId
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = [ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
    signIn.trySilentAuthentication()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
    
  }
}

