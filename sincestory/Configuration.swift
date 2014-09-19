//
//  Configuration.swift
//  sincestory
//
//  Created by Leo G Dion on 9/18/14.
//  Copyright (c) 2014 BrightDigit, LLC. All rights reserved.
//

import UIKit

var _configuration:Configuration = Configuration(bundle:NSBundle.mainBundle())

class Configuration {
  
  let google:Google
  
  private init (jsonFiles:[String] ) {
    var dictionaries = jsonFiles.map {
      (var filepath) -> NSDictionary  in
      var error: NSError?
      /*
      if let jsonData = NSData(contentsOfFile: filepath, options: .DataReadingMappedIfSafe, error: &error)
      {
        return NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as NSDictionary
      } else {
        return NSDictionary()
      }
*/
      let jsonData = NSData(contentsOfFile: filepath, options: .DataReadingMappedIfSafe, error: &error)
      return NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as NSDictionary
    }
    
    let json = dictionaries.reduce(Dictionary<String,AnyObject>(),{
      ($0, $1)
      var newDictionary = $1 as Dictionary<String, AnyObject>
      var result = Dictionary<String,AnyObject>()
      for (k, v) in $0 {
        result.updateValue(v, forKey: k)
      }
      for (k, v) in newDictionary {
        result.updateValue(v, forKey: k)
      }
      return result
    })
    
    let googleSettings:AnyObject? = json["google"]
    
    self.google = Google(settings: googleSettings as Dictionary<String, String>)
  }
  
  private convenience init (bundle:NSBundle) {
    self.init(jsonFiles:bundle.pathsForResourcesOfType("json", inDirectory: ".") as [String])
  }
  
  private convenience init () {
    self.init(bundle:NSBundle.mainBundle())
  }
  
  class var current:Configuration {
    /*
    if _configuration == nil {
    var paths = NSBundle.mainBundle()
    _configuration = Configuration(jsonFiles: paths)
    }
    */
    return _configuration
  }
  class Google {
    let clientID:String
    let clientSecret:String
    
    convenience init (settings: Dictionary<String, String>) {
      self.init(clientID: settings["client_id"]!, clientSecret: settings["client_secret"]!)
    }
    required init (clientID:String, clientSecret:String) {
      self.clientID = clientID
      self.clientSecret = clientSecret
    }
  }
}
