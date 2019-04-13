//
//  ViewController.swift
//  task-05p
//
//  Created by Lamphai Intathep on 7/4/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
/*

import UIKit

class ViewController: ViewController {//,UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createFileManagerObject()
    }
   
    func createFileManagerObject() {
        do {
            let path = Bundle.main.url(forResource: "cafe", withExtension: "json")
            let fm = FileManager.default
            let docurl = try fm.url(for:.documentDirectory,
                                 in: .userDomainMask, appropriateFor: nil, create: false)
            
            let myfile = docurl.appendingPathComponent("cafe.json")
            let filePath = myfile.path
            print(docurl)
            
            if fm.fileExists(atPath: filePath) {
                print("File found")
            } else {
            try fm.copyItem(at: path!, to: myfile)
                print("Copy succeeded")
            }
            
            let cafedata = fm.contents(atPath: filePath)
            let cafe = try JSONDecoder().decode([Cafe].self, from: cafedata!)
            print(cafe)
        } catch {
            print("Error")
        }
    }
}

*/
