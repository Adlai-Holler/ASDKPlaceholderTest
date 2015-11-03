//
//  ViewController.swift
//  ASDKPlaceholderTest
//
//  Created by Adlai Holler on 11/3/15.
//  Copyright © 2015 adlai. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ViewController: UIViewController, ASTableViewDataSource, ASTableViewDelegate {

	var tableView: ASTableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView = ASTableView(frame: view.bounds, style: .Plain, asyncDataFetching: true)
		tableView.asyncDataSource = self
		tableView.asyncDelegate = self
		view.addSubview(tableView)
		
		// avoid all the extra lines
		tableView.tableFooterView = UIView()
	}
	
	func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
		let node = PlaceholderLoadingNode()
		node.text = "Loading…"
		return node
	}

}

