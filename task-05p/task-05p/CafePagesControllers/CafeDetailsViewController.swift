//
//  CafeDetailsViewController.swift
//  D task
//
//  Created by Lamphai Intathep on 28/4/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//

import UIKit

class CafeDetailsViewController: UIViewController {

    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var showMapBtn: UIBarButtonItem!
    @IBOutlet weak var favouriteBtn: UIBarButtonItem!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var selectedCafe: Cafe?
    
    @IBOutlet weak var phoneLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        displaySelectedCafe()
    }
    
    //MARK: text starts in the top of the label
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func displaySelectedCafe() {
        if let cafeDetails = selectedCafe {
            cafeNameLabel.text = cafeDetails.name
            ratingLabel.text = "Rating: " + (NSString(format: "%.1f", cafeDetails.rating) as String)
            locationLabel.text = "Location: " + cafeDetails.location + " " + cafeDetails.suburb
            phoneLabel.text = "Phone: " + cafeDetails.phone
            offerLabel.text = "Special cups: " + cafeDetails.special
        }
    }
    
    @IBAction func showSelectedCafe(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "displayMap") as? MapViewController
        vc!.latitude = (selectedCafe?.latitude)!
        vc!.longitude = (selectedCafe?.longitude)!
        vc!.name = ((selectedCafe?.name)!)
        vc!.address = ((selectedCafe?.location)!)
        navigationController?.pushViewController(vc!, animated: true)
    }

}
