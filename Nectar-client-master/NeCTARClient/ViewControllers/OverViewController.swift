//
//  HomeViewController.swift
//  NeCTARClient
//
//  Created by Ding Wang on 16/8/14.
//  Copyright © 2016年 Ding Wang. All rights reserved.
//

import UIKit
import Charts
import MBProgressHUD

class OverViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var panGesture: UIPanGestureRecognizer!

    @IBOutlet var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var hudParentView = UIView()
    
    var titleOfOtherPages = ""
    let titles = ["Instances", "VCPUs", "RAM", "Volumes"]
    let label = ["Used", "Unused"]
    var data: [[Double]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hudParentView = self.view
        MBProgressHUD.showHUDAddedTo(hudParentView, animated: true)

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

        
        commonInit()
    }
    
    private func commonInit() {
        if let user = UserService.sharedService.user{
            let url = user.computeServiceURL
            let token = user.tokenID
            
            NeCTAREngine.sharedEngine.getLimit(url, token: token).then{ (json) -> Void in
                
                print(json)
                
                let absolute = json["limits"]["absolute"]
                let usedInstaces = absolute["totalInstancesUsed"].doubleValue
                let unUsedInstances = absolute["maxTotalInstances"].doubleValue - usedInstaces
                //self.data[0] = [usedInstaces, unUsedInstances]
                self.data.append([usedInstaces, unUsedInstances])
                
                
                let usedCpus = absolute["totalCoresUsed"].doubleValue
                let unUsedCpus = absolute["maxTotalCores"].doubleValue - usedCpus
                //self.data[1] = [usedCpus, unUsedCpus]
                self.data.append([usedCpus, unUsedCpus])
                
                let usedRAM = absolute["totalRAMUsed"].doubleValue
                let unUsedRAM = absolute["maxTotalRAMSize"].doubleValue - usedRAM
                //self.data[2] = [usedRAM, unUsedRAM]
                self.data.append([usedRAM, unUsedRAM])
                
                //let usedSG = absolute["totalSecurityGroupsUsed"].doubleValue
                //let unUsedSG = absolute["maxSecurityGroups"].doubleValue - usedSG
                //self.data.append([usedSG, unUsedSG])
                
//                print(self.data)
                
                MBProgressHUD.hideHUDForView(self.hudParentView, animated: true)
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                
                
                }.error{(err) -> Void in
                    var errorMessage:String = "Action Failed."
                    switch err {
                    case NeCTAREngineError.CommonError(let msg):
                        errorMessage = msg!

                    case NeCTAREngineError.ErrorStatusCode(let code):
                        if code == 401 {
                            loginRequired()
                        } else {
                            errorMessage = "Fail to get overview information."
                        }
                    default:
                        errorMessage = "Fail to get overview information."
                    }
                    PromptErrorMessage(errorMessage, viewController: self)
            }
            print(user.tenantID)
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            NeCTAREngine.sharedEngine.getVolumeLimit(user.volumeV3ServiceURL, projectId: user.tenantID ,token: token).then{ (json) -> Void in
                
                print(json)
                
                let absolute = json["limits"]["absolute"]
                let usedVolume = absolute["totalVolumesUsed"].doubleValue
                let unUsedVolume = absolute["maxTotalVolumes"].doubleValue - usedVolume
                //self.data[3] = [usedVolume, unUsedVolume]
                self.data.append([usedVolume, unUsedVolume])
                
                print(usedVolume)
                print(unUsedVolume)
                
                //                print(self.data)
                
                MBProgressHUD.hideHUDForView(self.hudParentView, animated: true)
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                
                
                }.error{(err) -> Void in
                    var errorMessage:String = "Action Failed."
                    switch err {
                    case NeCTAREngineError.CommonError(let msg):
                        errorMessage = msg!
                        
                    case NeCTAREngineError.ErrorStatusCode(let code):
                        if code == 401 {
                            loginRequired()
                        } else {
                            errorMessage = "Fail to get overview information."
                        }
                    default:
                        errorMessage = "Fail to get overview information."
                    }
                    PromptErrorMessage(errorMessage, viewController: self)
            }
            }

            
            NeCTAREngine.sharedEngine.listFlavors(url, token: token).then{ (json) -> Void in
//                print(json)
                let flavors = json["flavors"].arrayValue
                FlavorService.sharedService.clear();
                for flavor in flavors {
                    let fla = Flavor(json: flavor)
                    FlavorService.sharedService.falvors.append(fla!)
                    
                }

                }.error{(err) -> Void in
                    var errorMessage:String = "Action Failed."
                    switch err {
                    case NeCTAREngineError.CommonError(let msg):
                        errorMessage = msg!

                    default:
                        errorMessage = "Fail to get all flavors."
                    }
                    PromptErrorMessage(errorMessage, viewController: self)
            }
        }
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.data = []
        commonInit()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if data.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("OverviewCell") as! OverViewCell
            cell.setChart(label, values: data[indexPath.row] )
            cell.title.text = titles[indexPath.row]
        
            return cell
        }
        return UITableViewCell()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOtherPages" {
            if let a = segue.destinationViewController as? OtherPageViewController {
                a.PageTitle = titleOfOtherPages
            }
        }
    }
}
