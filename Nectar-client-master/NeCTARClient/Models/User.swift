//
//  User.swift
//  NeCTARClient
//
//  Created by Ding Wang on 16/8/4.
//  Copyright © 2016年 Ding Wang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    var tokenID: String
    var tenantID: String
    var tenantDescription: String
    var tenantName: String
    var dnsServiceURL: String
    var computeServiceURL: String
    var networkServiceURL: String
    var volumnV2ServiceURL: String
    var S3ServiceURL: String
    var alarmingServiceURL: String
    var imageServiceURL: String
    var meteringServiceURL: String
    var cloudformationServiceURL: String
    var applicationCatalogURL: String
    var volumnV1ServiceURL: String
    var EC2ServiceURL: String
    var orchestrationServiceURL: String
    var username: String
    var userId: Int
    var owner: String
    var volumeV3ServiceURL: String
    
    init?(json:JSON) {
        let accessInfo = json["access"]
        let token = accessInfo["token"]
        let serviceCatalog = accessInfo["serviceCatalog"].arrayValue
        let userInfo = accessInfo["user"]
        
        self.tokenID = token["id"].stringValue
        self.tenantName = token["tenant"]["name"].stringValue
        self.tenantID = token["tenant"]["id"].stringValue
        self.tenantDescription = token["tenant"]["description"].stringValue
        self.dnsServiceURL = serviceCatalog[0]["endpoints"][0]["publicURL"].stringValue
        self.computeServiceURL = serviceCatalog[1]["endpoints"][0]["publicURL"].stringValue
        self.networkServiceURL = serviceCatalog[2]["endpoints"][0]["publicURL"].stringValue
        self.volumnV2ServiceURL = serviceCatalog[3]["endpoints"][0]["publicURL"].stringValue
        self.S3ServiceURL = serviceCatalog[4]["endpoints"][0]["publicURL"].stringValue
        self.alarmingServiceURL = serviceCatalog[5]["endpoints"][0]["publicURL"].stringValue
        self.imageServiceURL = serviceCatalog[6]["endpoints"][0]["publicURL"].stringValue
        self.meteringServiceURL = serviceCatalog[7]["endpoints"][0]["publicURL"].stringValue
        self.cloudformationServiceURL = serviceCatalog[8]["endpoints"][0]["publicURL"].stringValue
        self.applicationCatalogURL = serviceCatalog[9]["endpoints"][0]["publicURL"].stringValue
        self.volumnV1ServiceURL = serviceCatalog[10]["endpoints"][0]["publicURL"].stringValue
        self.EC2ServiceURL = serviceCatalog[11]["endpoints"][0]["publicURL"].stringValue
        self.orchestrationServiceURL = serviceCatalog[12]["endpoints"][0]["publicURL"].stringValue
        self.username = userInfo["username"].stringValue
        self.userId = userInfo["id"].intValue
        self.owner = orchestrationServiceURL.componentsSeparatedByString("/")[4]
        self.volumeV3ServiceURL = "https://cinder.rc.nectar.org.au:8776/"
    }
    
}