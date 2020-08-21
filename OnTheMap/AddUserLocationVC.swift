//
//  AddUserLocationVC.swift
//  OnTheMap
//
//  Created by A Abdullah on 7/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class AddUserLocationVC: UIViewController, UISearchControllerDelegate {

    @IBOutlet weak var locationTextField : UITextField!
    @IBOutlet weak var findLocationButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        findLocationButton.layer.cornerRadius = 12
        locationTextField.setupPlaceholder(text: "Enter Your Location Here")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

    @IBAction func cancel(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender : UIButton) {
        
        guard let searchText = locationTextField.text, searchText.isEmpty == false else {
            Alert.BasicAlert(vc: self, message: "write your location string please")
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                Alert.BasicAlert(vc: self, message: "No Data For This City")
                return
            }
            let lat = response.boundingRegion.center.latitude
            let long = response.boundingRegion.center.longitude
            let userCoordinates = NewUserLocation(latitude: lat, longitude: long, mspString: searchText)
            self.performSegue(withIdentifier: "submitLocation", sender: userCoordinates)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as? SubmitLocationVC
        nextVC?.userLocation = (sender as! NewUserLocation)
    }
    

}
