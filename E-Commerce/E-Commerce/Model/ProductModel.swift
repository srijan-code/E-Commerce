//
//  ProductModel.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 27/07/22.
//

import Foundation

struct products: Codable {
    var id: Int?
    var name: String?
    var imageUrl: String?
    var merchantId: String?
    var categoryName: String?
    var catalogName: String?
    var price: Double?
    var strikePrice: Double?
    var usp: String?
    var description: String?
    var quantity: Int?
    var rating: Double?
    var ratingCount: Int?
    var dimension: String?
    var weight: String?
    var color: String?

    var listViewDetail: ListToDetailTransfer {
        var sendToPageDetails = ListToDetailTransfer()
        sendToPageDetails.productName = self.name
        sendToPageDetails.imageUrl = self.imageUrl
        sendToPageDetails.productDescription = self.description
        sendToPageDetails.productPrice = self.price
        sendToPageDetails.productColor = self.color
        sendToPageDetails.productWeight = self.weight
        sendToPageDetails.productDimension = self.dimension
        return sendToPageDetails
    }
}

struct ListToDetailTransfer {
    var imageUrl: String?
    var productName: String?
    var productDescription: String?
    var productPrice: Double?
    var productDimension: String?
    var productColor: String?
    var productWeight: String?
}


