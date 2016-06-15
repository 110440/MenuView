//
//  MenuView.swift
//
//  Created by tanson on 16/5/4.
//  Copyright © 2016年 tanson. All rights reserved.
//

import UIKit

private let viewAlpha:CGFloat = 0.7
private let screentSize = UIScreen.mainScreen().bounds.size


class MenuView: UIView {

    var edgePanGestureRecognizer:UIScreenEdgePanGestureRecognizer!
    var animateTabBar = true
    var showViewWidth:CGFloat = 0
    var startX:CGFloat = 0
    
    //底下黑色遮挡层
    lazy var backView:UIView = {
        let view = UIView(frame: self.bounds)
        view.alpha = 0
        view.backgroundColor = UIColor.blackColor()
        //点击收回menu
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var contentView:UIView = {
        let h = self.bounds.height
        let tableViewRect = CGRect(x: -self.showViewWidth, y: 0, width: self.showViewWidth, height: h)
        let view = UIView(frame: tableViewRect)
        view.backgroundColor = UIColor.darkGrayColor()
        return view
    }()
    
    init(frame:CGRect,showViewWidth:CGFloat){
        
        self.showViewWidth = showViewWidth
        super.init(frame: frame)

        self.userInteractionEnabled = false
        self.addSubview(self.backView)
        self.addSubview(self.contentView)
        
        //滑动弹出的 menu
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:)))
        self.addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate:MenuViewDeleaget? {
        didSet{
            let screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.edgePan(_:)))
            screenEdgeRecognizer.edges = .Left
            self.edgePanGestureRecognizer = screenEdgeRecognizer
            if let target = delegate as? UIViewController{
                target.view.addGestureRecognizer(screenEdgeRecognizer)
            }else if let target = delegate as? UIView{
                target.addGestureRecognizer(screenEdgeRecognizer)
            }

            let showView = delegate!.viewToShowForMenuView(self)
            showView.frame = self.contentView.bounds
            self.contentView.addSubview(showView)
        }
    }
    
    func showMenu(speed:CGFloat = 600){
        
        let d = Double(abs(self.contentView.frame.minX) / speed)
        UIView.animateWithDuration(d, animations: {
            self.contentView.frame.origin.x = 0
            self.backView.alpha = viewAlpha
            self.tabBar?.alpha = 0
            self.tabBar?.frame.origin.y = screentSize.height
        }){ end in
            self.userInteractionEnabled = true
        }
    }
    
    func hideMenu(speed:CGFloat = 800){
        
        let d = Double(abs(self.contentView.frame.maxX) / speed)
        UIView.animateWithDuration(d, animations: {
            self.contentView.frame.origin.x = -self.showViewWidth
            self.backView.alpha = 0
            
            if let tabBar = self.tabBar{
                tabBar.alpha = 1
                tabBar.frame.origin.y = screentSize.height - tabBar.frame.height
            }
        }){ end in
            self.userInteractionEnabled = false
        }
    }
    
    private var tabBar:UITabBar?{
        if self.animateTabBar == false { return nil }
        let vc = self.delegate as? UIViewController
        return vc?.tabBarController?.tabBar
    }
    
    // 按百分比显示tabBar
    private func showTabBarByPercentage(p:CGFloat){
        if let tabBar = self.tabBar {
            let barHeight = tabBar.frame.height
            let y = screentSize.height - (barHeight * (1-p))
            tabBar.frame.origin.y = y
            tabBar.alpha = 1 - p * viewAlpha
        }
    }
    
    // x = (-self.showViewWidth ~ 0 )
    private func panChangedAction(showViewX:CGFloat){
        var x = min(0, showViewX)
        x = max(x, -self.showViewWidth)
        self.contentView.frame.origin.x = x
        
        //完成百分比
        let p = (self.showViewWidth + x)/self.showViewWidth
        self.backView.alpha = p * viewAlpha
        self.showTabBarByPercentage(p)
        self.delegate?.MenuViewShowPercentage?(Float(p))
    }
    
    //MARK: GestureRecognizer action
    
    func tap(sender:UITapGestureRecognizer){
        if sender.state == .Ended{
            self.hideMenu()
        }
    }
    
    func pan(sender:UIPanGestureRecognizer){
        
        let state = sender.state
        if state == .Began{
            self.startX = sender.locationInView(self).x
            
        }else if state == .Changed{
            let location = sender.locationInView(self)
            let dx = location.x - self.startX
            self.startX = location.x
            let x = self.contentView.frame.origin.x + dx
            self.panChangedAction(x)

        }else if state == .Cancelled || state == .Ended {
            let v = sender.velocityInView(self.backView)
            if v.x <= -300 {
                self.hideMenu(abs(v.x))
            }else if v.x > 300{
                self.showMenu(v.x)
            }else if self.contentView.frame.minX < -self.showViewWidth/2 {
                self.hideMenu()
            }else{
                self.showMenu()
            }
        }
    }
    
    
    func edgePan(sender: UIScreenEdgePanGestureRecognizer){
        if sender.state == .Began || sender.state == .Changed{
            let location = sender.locationInView(self.superview)
            let x = -self.showViewWidth + location.x
            self.panChangedAction(x)
            
        }else if sender.state == .Cancelled || sender.state == .Ended{
            let location = sender.locationInView(self.superview)
            let v = sender.velocityInView(self.superview)
            if v.x > 300 {
                self.showMenu(v.x)
            }else if location.x >= self.showViewWidth/2{
                self.showMenu()
            }else{
                self.hideMenu()
            }
        }
    }
    
}

//MARK:- Menuview protocol
@objc protocol MenuViewDeleaget:NSObjectProtocol {
    optional func MenuViewShowPercentage(p:Float)
    func viewToShowForMenuView(menu:UIView)->UIView
}
