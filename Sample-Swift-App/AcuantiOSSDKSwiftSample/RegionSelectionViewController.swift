//
//  RegionSelectionViewController.swift
//  AcuantiOSSDKSwiftSample
//
//  Created by Tapas Behera on 7/28/17.
//  Copyright © 2017 Acuant. All rights reserved.
//

import Foundation

class RegionSelectionViewController:UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var regions = [String]()
    var selectionDelegate:RegionSelectionDelegate!
    
    var regionMap = ["United States":AcuantCardRegionUnitedStates,
                            "Canada": AcuantCardRegionCanada,
                            "Europe": AcuantCardRegionEurope,
                            "Africa": AcuantCardRegionAfrica,
                            "Asia" : AcuantCardRegionAsia,
                            "Latin America" : AcuantCardRegionAmerica,
                            "Australia" : AcuantCardRegionAustralia] as [String : AcuantCardRegion]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        regions = ["United States", "Canada", "Europe", "Africa", "Asia", "Latin America", "Australia"]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = regions[indexPath.row];
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion:{
            self.selectionDelegate!.didSelectRegion(regionID: self.regionMap[self.regions[indexPath.row]]!)
        })
    }
}
