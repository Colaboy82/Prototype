//
//  TableView.swift
//  Consent
//
//  Created by Grumpy1211 on 1/1/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import SkeletonView

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEntriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let cell = tableViewU.dequeueReusableCell(withIdentifier: "cell") as! ConsentEntryCell
        
        let entry: ConsentEntryModel
        
        entry = filteredEntriesList[indexPath.row]
        var pic: UIImage!
        
        if (pic == nil){
            cell.profilePicImg.showAnimatedGradientSkeleton()
            cell.mainView.showAnimatedGradientSkeleton()
        }
        
        cell.dateLbl.text = entry.date
        let name = entry.firstName + " " + entry.midName + " " + entry.lastName
        cell.nameLbl.text = name
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: entry.profilePicUrl)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            cell.profilePicImg.hideSkeleton()
            cell.mainView.hideSkeleton()
            pic = UIImage(data: data!)
            cell.profilePicImg.image = pic
        }
        
        return cell
    }
}

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! ConsentEntryCell
        let entry: ConsentEntryModel
        //getting the thought of selected position
        entry = entriesList[(indexPath.row)]
        
        //main Page
        ClickedEntryVC.profilePicUrl = entry.profilePicUrl
        ClickedEntryVC.date = entry.date
        ClickedEntryVC.name = entry.firstName + " " + entry.midName + " " + entry.lastName
        ClickedEntryVC.gender = entry.gender
        ClickedEntryVC.email = entry.email
        
        //Contract
        ContractVC.sig1Url = entry.firstSignature
        ContractVC.sig2Url = entry.secondSignature
        ContractVC.agreedActions = entry.agreedActions
        
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "ClickedEntry")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    
}

public protocol SkeletonTableViewDataSource: UITableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier
}
