//
//  CafeDetailsViewController.swift
//  task-07p
//
//  Created by Lamphai Intathep on 28/4/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//

import UIKit

class CafeDetailsViewController: UIViewController {

    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeDetailsLabel: UILabel!
    @IBOutlet weak var showMapBtn: UIBarButtonItem!
    var selectedCafe: Cafe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displaySelectedCafe()
    }
    
    //MARK: text starts in the top of the label
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cafeDetailsLabel.sizeToFit()
    }
    
    func displaySelectedCafe() {
        if let cafeDetails = selectedCafe {
            cafeNameLabel.text = cafeDetails.name
            cafeDetailsLabel.text = "Rating: " + (NSString(format: "%.1f", cafeDetails.rating) as String) + "\nLocation: " + cafeDetails.location + "\nPhone: " + cafeDetails.phone
        }
    }
    
    @IBAction func showSelectedCafe(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "displayMap") as? MapViewController
        vc!.latitude = ((selectedCafe)?.coordinate.latitude)!
        vc!.longitude = (selectedCafe?.coordinate.longitude)!
        vc!.name = ((selectedCafe?.name)!)
        vc!.address = ((selectedCafe?.location)!)
        navigationController?.pushViewController(vc!, animated: true)
    }

}
