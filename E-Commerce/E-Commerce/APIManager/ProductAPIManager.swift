//
//  ProductAPIManager.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 27/07/22.
//

import UIKit

protocol ProductListManagerDelegate {
    func updateData(productDetail: [products])
}

class ProductAPIManager: UIViewController
{
    var delegate: ProductListManagerDelegate?
    func fetchProductList(searchItem: String)
    {
        let urlString =  "http://10.20.4.154:8080/product/categoryname/\(searchItem)"
        performRequest(with: urlString)
    }
    
    func fetchProductListUsingSearch(searchItem: String)
    {
        let urlString =  "http://10.20.4.154:8080/product/productname/\(searchItem)"
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
                        self?.delegate?.updateData(productDetail: fetchedData)
                    }
                }
            }
            task.resume()
        } else {
            print("Failed to parse URL String: \(urlString)")
        }
    }
    
    func parseJSON(_ productData: Data) -> [products]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([products].self, from: productData)
            return decodedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}




