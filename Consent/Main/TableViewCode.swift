//
//  TableView.swift
//  Consent
//
//  Created by Grumpy1211 on 1/1/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewU.dequeueReusableCell(withIdentifier: "cell")! //1.
        
        let text = "test \(indexPath.row)"  //2.
        
        cell.textLabel?.text = text //3.
        
        return cell //4.
    }
    
    
}
