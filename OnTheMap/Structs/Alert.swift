//
//  Alert.swift
//  OnTheMap
//
//  Created by A Abdullah on 7/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

// Alert implementation ..
//in the (BasicAlert) the user have one option but in (overwriteAlert) are have two options with handler..
struct Alert {
    static func BasicAlert(vc: UIViewController, message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }

    static func overwriteAlert(on vc : UIViewController, message : String, completion : @escaping ()->()) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
            completion()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    
    
}
