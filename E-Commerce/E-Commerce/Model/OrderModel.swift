//
//  OrderModel.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 01/08/22.
//

import Foundation

struct Order: Codable {
    let id: String?
    let cartList: [Cart]?
    let price: Int?
    let mailId: String?
    let date: String?
}

struct CartList: Codable {
    let id: String?
    let product: Product?
    let productId, quantity: Int?
    let emailId: String?
}


struct Product: Codable {
    let id: Int?
    let name: String?
    let imageUrl: String?
    let merchantId, categoryName: String?
    let price, strikePrice: Double?
    let usp, description: String?
    let quantity, soldQuantity: Int?
    let rating: Double?
    let ratingCount: Int?
}

