//
//  ViewController.swift
//  ScreenEdgePanGesture
//
//  Created by tanson on 16/5/4.
//  Copyright © 2016年 tanson. All rights reserved.
//

import UIKit

let viewWidth:CGFloat = 300

class ViewController: UIViewController ,UITableViewDataSource,MenuViewDeleaget{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: self.view.bounds)
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        let menu = MenuView(w:viewWidth, h: self.view.bounds.height)
        menu.delegate = self
        self.view.addSubview(menu)
    }

    //MARK: tableView delegate

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        cell.textLabel?.text = "sssss\(indexPath.row)"
        return cell
    }
    
    ///MenuView delegate
    func numberOfSectionsForMenuView(view: MenuView) -> Int {
        return 2
    }
    func numberOfRowsInSectionForMenuView(view: MenuView, section: Int) -> Int {
        return 3
    }
    func menuView(view: MenuView, willShowCell cell: UITableViewCell, indexPath: NSIndexPath) {
        cell.textLabel?.text = "收件箱"
    }
    func menuView(view: MenuView, selectRowAtIndexPath indexPath: NSIndexPath) {
        print("select at \(indexPath.row)")
    }

}

