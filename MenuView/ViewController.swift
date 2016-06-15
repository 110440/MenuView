//
//  ViewController.swift
//  ScreenEdgePanGesture
//
//  Created by tanson on 16/5/4.
//  Copyright © 2016年 tanson. All rights reserved.
//

import UIKit


private let profileViewWidth:CGFloat = UIScreen.mainScreen().bounds.width * 2/3

class ViewController: UIViewController ,MenuViewDeleaget,UITableViewDataSource{

    
    var menu: MenuView!
    
    lazy var profileView:UITableView = {
        let view = UITableView(frame: CGRectZero, style: .Grouped)
        view.dataSource = self
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: profileViewWidth, height: profileViewWidth * 2/3 ))
        headView.backgroundColor = UIColor.redColor()
        view.tableHeaderView = headView
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "主页"
        
        self.setupMenuView()
    }

    
    func setupMenuView(){
        let menu = MenuView(frame: self.view.bounds, showViewWidth:profileViewWidth)
        menu.delegate = self
        self.view.addSubview(menu)
    }
    
    //MARK: menu delegate
    func viewToShowForMenuView(menu: UIView) -> UIView {
        return self.profileView
    }
    
    //MARK: profile tableView Delegate
    var profileCellName = [["资料","文章","收藏","好友"],["设置"]]
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return profileCellName.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCellName[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil{
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        
        cell?.accessoryType = .DisclosureIndicator
        cell?.textLabel?.text = profileCellName[indexPath.section][indexPath.row]
        return cell!
    }


}

