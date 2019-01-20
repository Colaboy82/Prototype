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
        self.tableViewU.reloadData()
    }
    
    func updateFilteredEntries(nameB: Bool){
        filteredEntriesList.removeAll()
        var hold = ""
        for n in self.entriesList{
            let name = n.firstName + " " + n.midName + " " + n.lastName
            for nameSearched in filteredList{
                if (nameSearched == name && !n.date.elementsEqual(hold)){
                    self.filteredEntriesList.append(n)
                    hold = n.date
                }
            }
        }
    }
}
