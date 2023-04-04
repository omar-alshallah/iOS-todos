//
//  ViewController.swift
//  MVC
//
//  Created by Omar Alshallah Mhd Wajih on 22/03/2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var getDataButton: UIButton!
    
    @IBOutlet weak var quakesTableView: UITableView!
    
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    var todosList = [Todo]() {
        didSet {
            DispatchQueue.main.async {
                self.quakesTableView.reloadData()
            }
        }
    }
    
    var locationManager: CLLocationManager?
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadingIndicator.frame = view.frame
        loadingIndicator.hidesWhenStopped = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }

    @IBAction func getDataButtonTabbed(_ sender: Any) {
        if locationManager?.authorizationStatus == .authorizedWhenInUse {
            locationManager?.requestLocation()
        }
        getTodosList()
    }
    
    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
        view.addSubview( )
    }
    
    func hideLoadingIndicator() {
        
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
    
    func showAlertWithTitle(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",style: .default)
        alert.addAction(action)
        self.present(alert, animated: false)
    }
    
    func getTodosList() {
        
        showLoadingIndicator()
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/") else { return }
     
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let dataResponse = data, error == nil else {
                print(error?.localizedDescription ?? "Something went wrong")
                return
            }
            
            do {
//                let response = try JSONSerialization.jsonObject(with: dataResponse, options: [])
//                print(response)
                self.hideLoadingIndicator()
                let decoder = JSONDecoder()
                let todos = try decoder.decode([Todo].self, from: dataResponse)
                self.todosList = todos
                
            } catch let parsingError {
                print("--- PARSING ERROR ---", parsingError)
            }
        }
        
        task.resume()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = todosList[indexPath.row].title
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = todosList[indexPath.row]
        showAlertWithTitle(title: "Note", message: "You have selected \(selectedTodo.title)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        if let location = locations.first {
            print("lat: \(location.coordinate.latitude), long: \(location.coordinate.longitude)")
            
            userLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("IN USE PERMMISSION GRANTED")
            locationManager?.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
