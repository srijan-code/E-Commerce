//
//  CartAPIManager.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 28/07/22.
//

import Foundation
import UIKit

protocol CartManagerDelegate {
    func updateData(cartDetail: [Cart])
}

class CartAPIManager: UIViewController{
    var delegate: CartManagerDelegate?
    
    func fetchProductList(userEmail: String)
    {
        let urlString =  "http://10.20.4.154:8082/cart/\(userEmail)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String)
    {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){
                [weak self] (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let safeData = data{
                    print("URL: \(urlString) succesful, withData: \(safeData)")
                    if let fetchedData = self?.parseJSON(safeData){
                        self?.delegate?.updateData(cartDetail: fetchedData)
                    }
                }
            }
            task.resume()
        } else {
            print("Failed to parse URL String: \(urlString)")
        }
    }
    
    func parseJSON(_ productData: Data) -> [Cart]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([Cart].self, from: productData)
            return decodedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
