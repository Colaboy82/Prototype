//
//  SearchBar.swift
//  Consent
//
//  Created by Grumpy1211 on 1/19/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase

/*  nameType = false -> search parameter is date
 *  nameType = true -> search parameter is name
 */

extension MainVC {
    
    //tableViewU
    //searchBar

    @objc func textFieldDidChange(_ textfield: UITextField) {
        filteredList.removeAll()

        if(!nameType){
            if textfield.text?.count != 0 {
                for strName in nameList {
                    let range = strName.range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                    if range != nil {
                        filteredList.insert(strName, at: 0)
                    }
                }
            } else {
                filteredList = nameList
            }
            updateFilteredEntries(nameB: true)
        } else {
            if textfield.text?.count != 0 {
                for strName in dateList {
                    let range = strName.range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                    if range != nil {
                        filteredList.insert(strName, at: 0)
                    }
                }
            } else {
                filteredList = dateList
            }
            updateFilteredEntries(nameB: false)
        }
        self.tableViewU.reloadData()
    }
    
    func updateFilteredEntries(nameB: Bool){
        filteredEntriesList.removeAll()
        var hold = ""
        if (nameB) {
            for n in self.entriesList{
                let name = n.firstName + " " + n.lastName
                for nameSearched in filteredList{
                    if (nameSearched == name && !n.date.elementsEqual(hold)){
                        self.filteredEntriesList.append(n)
                        hold = n.date
                    }
                }
            }
        } else {
            for n in self.entriesList{
                let date = n.date
                for dateSearched in filteredList{
                    if (dateSearched == updateDate(date: date) && !n.date.elementsEqual(hold)){
                        self.filteredEntriesList.append(n)
                        hold = n.date
                    }
                }
            }
        }
    }
    func updateDate(date: String) -> String {
        var updatedDate = date
        if let comma = updatedDate.firstIndex(of: ",") {
            updatedDate = updatedDate.substring(to: comma)
        }
        return updatedDate
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.y > 0){
            self.topSearchBarConstraint.constant = self.initialTopBarConstraint
            self.topTableViewConstraint.constant = self.initalTopTableViewConstraint
            UIView.animate(withDuration: 0.5, animations: {//scrolling down
                self.view.layoutIfNeeded()
            })
        }else{
            // Dragging up
            self.topSearchBarConstraint.constant = self.initialTopBarConstraint - self.searchView.frame.height
            self.topTableViewConstraint.constant = self.initalTopTableViewConstraint - self.searchView.frame.height
            UIView.animate(withDuration: 0.5, animations: {// scrolling up
                self.view.layoutIfNeeded()
            })
        }
    }
}
