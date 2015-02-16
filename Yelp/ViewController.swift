//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var client: YelpClient!
    var businesses = [Business]()
    var allBusinesses = [Business]()
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerNib(UINib(nibName: "BusinessViewCell", bundle: nil), forCellReuseIdentifier: "BusinessViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        
        var searchBarView = UISearchBar()
        self.navTitle.titleView = searchBarView
        searchBarView.delegate = self

        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        self.requestBusinessesWithQuery("Fun", params: [:])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as FiltersViewController
        vc.delegate = self
    }
    
    func hideKeyboard(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func requestBusinessesWithQuery(query: NSString, params: NSDictionary) {
        client.searchWithTerm(query, params: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //            println(response)
            var businessDictionaries = response.objectForKey("businesses") as NSArray
            
            self.businesses = Business.businessesWithDictionaries(businessDictionaries)
            self.allBusinesses = self.businesses
            
            self.tableView.reloadData()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("BusinessViewCell") as BusinessViewCell
        cell.business = self.businesses[indexPath.row] as Business
        return cell;
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (cell.respondsToSelector(Selector("separatorInset"))) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        // Prevent the cell from inheriting the Table View's margin settings
        if (cell.respondsToSelector(Selector("preservesSuperviewLayoutMargins"))) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if (cell.respondsToSelector(Selector("layoutMargins"))) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
}

// MARK: - FilterViewDelelgate
extension ViewController: FilterViewDelegate {
    
    func filtersChanged(filtersViewController: FiltersViewController, filters: NSDictionary) {
        self.requestBusinessesWithQuery("Fun", params: filters)
        NSLog("fired \(filters)")
    }
    
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        NSLog("what the fuck")
        if(searchText.isEmpty) {
            businesses = allBusinesses
            dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
                self.hideKeyboard(searchBar)
            }
        } else {
            businesses = businesses.filter {
                var name = $0.name
                return name.rangeOfString(searchText, options: .RegularExpressionSearch) != nil
            }
        }
        
        tableView.reloadData()
    }
}
