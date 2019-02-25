//
//  AddressViewController.swift
//  SignUpValidation
//
//  Created by cl-macmini-110 on 21/02/19.
//  Copyright © 2019 cl-macmini-110. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class AddressViewController:UIViewController,UISearchBarDelegate {
    @IBAction func BackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var ViewOutlet: UIView!
    @IBAction func search(_ sender: Any) {
        let searchCont = UISearchController(searchResultsController: nil)
        searchCont.searchBar.delegate = self
        self.present(searchCont, animated: true, completion: nil)
    }
    
    
    var googlemapsview : GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.googlemapsview = GMSMapView(frame: self.ViewOutlet.frame)
        self.view.addSubview(self.googlemapsview)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension AddressViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again. `
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
