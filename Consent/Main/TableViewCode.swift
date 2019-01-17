//
//  TableView.swift
//  Consent
//
//  Created by Grumpy1211 on 1/1/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewU.dequeueReusableCell(withIdentifier: "cell") as! ConsentEntryCell
        
        let entry: ConsentEntryModel
        
        entry = entriesList[indexPath.row]
        
        cell.dateLbl.text = entry.date
        let name = entry.lastName + ", " + entry.firstName + " " + entry.midName
        cell.nameLbl.text = name
        
        return cell
    }
    
}

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
