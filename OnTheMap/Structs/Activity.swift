//
//  Activity.swift
//  OnTheMap
//
//  Created by A Abdullah on 7/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

//IMPLEMENT the Activity Indicator and call it anywhere.
struct ActivityIndicator {
    private static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    // proparity of ActivityIndicator
    static func startActivity(view: UIView){
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    //Stop ActivityIndicator..
    static func stopActivity(){
        activityIndicator.stopAnimating()
    }
}
