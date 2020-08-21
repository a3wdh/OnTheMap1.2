//
//  StudentsListVC.swift
//  OnTheMap
//
//  Created by A Abdullah on 7/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import SafariServices

class StudentsListVC: UITableViewController {

    let cellid = "cellid"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // register tableViewCell with UINib
        tableView.register(UINib(nibName: "StudentTableViewCell", bundle: nil), forCellReuseIdentifier: cellid)
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
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MapVC.students.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! StudentTableViewCell
        let student = MapVC.students[indexPath.row]
        cell.studentNameLabel.text = student.firstName! + " " + student.lastName!
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let toOpen = MapVC.students[indexPath.row].mediaURL {
            guard let url = URL(string: toOpen) else {return}
            openUrlInSafari(url:url)
        }
    }
    
    // Open  URL in safari
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

}
