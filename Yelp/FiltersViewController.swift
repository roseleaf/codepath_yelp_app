//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Rose Trujillo on 2/15/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

protocol FilterViewDelegate {
    func filtersChanged(filtersViewController: FiltersViewController, filters: NSDictionary)
}

class FiltersViewController: UIViewController {
    var delegate: FilterViewDelegate!
    var filters = NSMutableDictionary()
    var categories = [NSDictionary]()
    var selectedCategories = NSMutableSet()

    @IBOutlet weak var tableView: UITableView!

    func initWithNibName(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        //code
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCategories()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerNib(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupFilters() -> NSDictionary {
        if (selectedCategories.count > 0) {
            var names:NSMutableArray = []
            for dict in selectedCategories {
                names.addObject(dict["code"] as String)
            }
            var categoryFilter = names.componentsJoinedByString(",")
            filters.setValue(categoryFilter, forKey: "category_filter")
        }
        return filters
    }

    func initCategories() {
        categories = [
            [   "name": "Lakes",
                "code": "lakes"
            ],
            [   "name": "Leisure Centers",
                "code": "leisure_centers"
            ],
            [
                "name": "Music Venues",
                "code": "musicvenues"
            ]
        ]
    }
    
    // MARK: - IB Actions
    @IBAction func onApplyButtonPressed(sender: AnyObject) {
    navigationController?.popToRootViewControllerAnimated(true)
        print(self.delegate)
        setupFilters()
        self.delegate?.filtersChanged(self, filters: filters)
    }

    @IBAction func onCancelButtonPressed(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}

// MARK: - FilterTableViewCellDelegate
extension FiltersViewController: FilterTableViewCellDelegate {
    func switchCellValueDidChange(filterCell: FilterTableViewCell, value: Bool) {
        var indexPath = tableView.indexPathForCell(filterCell)
        if (value) {
            selectedCategories.addObject(categories[indexPath!.row])
        } else {
            selectedCategories.removeObject(categories[indexPath!.row])
        }
        
    }
}

// MARK: - UITableViewDataSource
extension FiltersViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
}

// MARK: - UITableViewDelegate - cell for row
extension FiltersViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FilterTableViewCell") as FilterTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.nameLabel.text = categories[indexPath.row].objectForKey("name") as? String
        cell.on = selectedCategories.containsObject(categories[indexPath.row])
        cell.delegate = self
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
