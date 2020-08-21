//
//  MapVC.swift
//  OnTheMap
//
//  Created by A Abdullah on 7/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    static var students = [StudentData]()
    
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // show students when view appears
        getAllStudents()
    }
    
    @IBAction func refreshStudentsData(_ sender: UIBarButtonItem) {
        
        // show students when refresh button tapped and pressed
        
        getAllStudents()
    }
    
    
    
    @IBAction func addUserLocationAction(_ sender: UIBarButtonItem) {
        // show alert to ask the user to overwrite his location or not
        Alert.overwriteAlert(on: self, message: "you have already posted student location. Would you like to overwrite your current location?") {
            self.performSegue(withIdentifier: "addUserLocation", sender: nil)
        }
    }
    
    @IBAction func deleteSessionAction(_ sender: UIBarButtonItem) {
        API.share.deleteSession {
            // show loginVC after delete the session
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(identifier: "login") as! LoginVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    func getAllStudents() {
        MapVC.students.removeAll()
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        API.share.getStudentsData { (studentsData, error) in
            // show error message when any error occured
            if error != nil {
                Alert.BasicAlert(vc: self, message: "can't get student data")
                return
            }
            
            if let data = studentsData?.results {
                MapVC.students = data
                self.manageMapPins()
            }
        }
        
        API.share.getUpdatedStudentsData { (studentData, error) in
            if error != nil {
                Alert.BasicAlert(vc: self, message: "error to get updated students data")
                return
            }
            if let data = studentData?.results {
                for i in data {
                    MapVC.students.append(i)
                }
                self.manageMapPins()
            }
        }
        refreshButton.isEnabled = true
    }
    
    func manageMapPins() {
        for student in MapVC.students {
            if let firstName = student.firstName, let lastName = student.lastName, let longitude = student.longitude , let latitude = student.latitude, let mediaURL = student.mediaURL {
                
                let fullName = firstName + " " + lastName
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = fullName
                annotation.subtitle = mediaURL
                
                annotations.append(annotation)
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.annotations)
            }
        }
    }
}

extension MapVC : MKMapViewDelegate {
    
    //  Set all pins on the mapView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView!.canShowCallout = true
            annotationView!.pinTintColor = .red
            annotationView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
        }
        else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    // Open the URL in safari web browser
    func openUrlInSafari(url:URL){
        if url.absoluteString.contains("http://"){
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }else {
            DispatchQueue.main.async {
                Alert.BasicAlert(vc: self, message: "Cannot Open , Because it's Not Vailed Website !!")
            }
        }
        
    }
    
    // Open system browser in URL specified in the annotationViews subtitle property
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                guard let url = URL(string: toOpen) else {return}
                openUrlInSafari(url:url)
            }
        }
    }
    
}
