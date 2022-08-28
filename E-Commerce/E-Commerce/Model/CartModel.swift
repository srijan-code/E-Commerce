//
//  CartModel.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 28/07/22.
//

import Foundation

struct Cart: Codable{
    var productId: Int?
    var quantity: Int?
    var emailId: String?
    var id: String?
    var product: ProductInfo?
}

struct ProductInfo: Codable {
    var id: Int?
    var name: String?
    var imageUrl: String?
    var price: Double?
    var quantity: Int?
}

struct SendDetails: Codable{
    var cartList: [Cart]?
    var mailId: String?
}
