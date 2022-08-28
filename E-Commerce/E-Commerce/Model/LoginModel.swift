//
//  LoginModel.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 30/07/22.
//

import Foundation

struct LoginCredential: Codable {
    var mailId : String?
    var password : String?
    var isMerchant : Bool?
    var isCustomer : Bool?
    var merchant : Bool?
}
