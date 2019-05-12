//
//  CafeCell.swift
//  D task
//
//  Created by Lamphai Intathep on 5/5/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//

import UIKit

class CafeCell: UITableViewCell {
    
    var link: TableViewController?
    var cafes = [Cafe]()
    //var cafes: [[String: Any]] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addHeartButton()
    }
    
    func addHeartButton() {
        let filledHeartBtn = UIButton(type: .system)
        filledHeartBtn.setImage(UIImage(named: "heart.png"), for: .normal)
        filledHeartBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //filledHeartBtn.tintColor = .gray
        filledHeartBtn.addTarget(self, action: #selector(handleMarkAsFavourite), for: .touchUpInside)
        accessoryView = filledHeartBtn
    }

    @objc func handleMarkAsFavourite() {
        link?.isFavouritePressed(cell: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
