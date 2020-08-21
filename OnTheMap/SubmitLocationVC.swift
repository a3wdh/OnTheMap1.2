//
//  SubmitLocationVC.swift
//  OnTheMap
//
//  Created by A Abdullah on 7/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class SubmitLocationVC: UIViewController {

    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    var userLocation : NewUserLocation?
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.layer.cornerRadius = 12
        linkTextField.setupPlaceholder(text: "Enter a Link to Share Here")
        
        // TO SET white placeholder
        
        setAnnotation()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // SET user annotation on mapKit
    func setAnnotation() {
        if let latitude = userLocation?.latitude, let longitude = userLocation?.longitude {
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(region, animated: true)
        }
    }
    

    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        guard let link = linkTextField.text else {
            Alert.BasicAlert(vc: self, message: "write youe media link please")
            return
        }
        
        // posting user new location
        API.share.postStudentLocation(uniqueKey: (LoginVC.userInformation?.session.id!)!, mapString: (userLocation?.mspString)!, mediaURL: link, latitude: (userLocation?.latitude)!, longitude: (userLocation?.longitude)!) { (success) in
            if success {
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(identifier: "tabbar")
                    vc!.modalPresentationStyle = .fullScreen
                    self.present(vc!, animated: true, completion: nil)
                }
            } else {
                Alert.BasicAlert(vc: self, message: "Posting Student Location Failed")
            }
        }
        
        
    }
    
    
    
    
}


