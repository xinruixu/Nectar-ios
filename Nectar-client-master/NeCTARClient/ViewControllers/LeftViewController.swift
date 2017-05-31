//
//  LeftViewController.swift
//  NeCTARClient
//
//  Created by Ding Wang on 16/8/14.
//  Copyright © 2017年 Xinrui Xu. All rights reserved.
//

import UIKit
import SnapKit

class LeftViewController: BaseViewController {
    
    @IBOutlet var tenantName: UILabel!
    @IBOutlet var userName: UILabel!

    @IBOutlet var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // add constrains to make the menu weigth is appriate for the screen
        self.contentView.snp_makeConstraints{ (make) -> Void in
            make.width.equalTo(Common.screenWidth * 0.8)
        }
        self.tenantName.snp_makeConstraints{(make) -> Void in
            make.width.equalTo(Common.screenWidth * 0.8 - 80 )
        }
        self.userName.snp_makeConstraints{(make) -> Void in
            make.width.equalTo(Common.screenWidth * 0.8 - 80)
        }
        
        tenantName.text = UserService.sharedService.user?.tenantName
        userName.text = UserService.sharedService.user?.username
    }
    
    @IBAction func toOverView(sender: AnyObject) {
        turnToOtherPage("Overview")
    }
    
    @IBAction func toInstance(sender: AnyObject) {
        turnToOtherPage("Instance")
    }
    
    @IBAction func toAbout(sender: AnyObject) {
        turnToOtherPage("About")
    }
    
    @IBAction func toVolumes(sender: AnyObject) {
        turnToOtherPage("Volumes")
    }
    // button hidden and disabled
    @IBAction func toImage(sender: AnyObject) {
        turnToOtherPage("Images")
    }

    // buton hidden and disabled
    @IBAction func toSecurity(sender: AnyObject) {
        turnToOtherPage("Access & Security")
    }
    
    @IBAction func logout(sender: AnyObject) {
        UserService.sharedService.logout()
        loginRequired ()
    }
    
    func turnToOtherPage (title: String) {
        
        let viewController = UIApplication.sharedApplication().keyWindow?.rootViewController as! ViewController
        viewController.homeViewController.titleOfOtherPages = title
        if(title != "Overview"){
            viewController.homeViewController.performSegueWithIdentifier("showOtherPages", sender: self)
        }
        viewController.showHome()
    }
}
