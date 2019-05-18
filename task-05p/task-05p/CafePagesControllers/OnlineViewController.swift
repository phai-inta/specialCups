//
//  OnlineCafeViewController.swift
//  task-05p
//
//  Created by Lamphai Intathep on 12/5/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class OnlineViewController: UIViewController {


    var onlineCafe: OnlineCafe?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        displayCafe()
    }
    
    func displayCafe() {
        super.viewDidLoad()
        nameLabel.text = onlineCafe?.name
        ratingLabel.text = (NSString(format: "%.1f", onlineCafe!.rating) as String)
        addressLabel.text = onlineCafe?.location
           let url = onlineCafe?.image
        
        Alamofire.request(url!).responseImage { response in
            if let image = response.result.value {
                self.imageLabel.image = image
            } else {
                print("error")
            }
        }
    }
    
    @IBAction func mapButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "displayMap") as? MapViewController
        vc!.latitude = (onlineCafe?.latitude)!
        vc!.longitude = (onlineCafe?.longitude)!
        vc!.name = ((onlineCafe?.name)!)
        vc!.address = ((onlineCafe?.location)!)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
