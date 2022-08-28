//
//  RecommendationAPIManager.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 29/07/22.
//

import UIKit
protocol RecommendationManagerDelegate {
    func updateData(productDetail: [products])
}


class RecommendationAPIManager: UIViewController {
    var delegate: RecommendationManagerDelegate?
    
    func fetchProductList(searchItem: String)
    {
        print("running")
        let urlString =  "http://10.20.4.154:8080/product/rec"
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
