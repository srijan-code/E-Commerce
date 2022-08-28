//
//  ProductDetailPageViewController.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 27/07/22.
//

import UIKit

class ProductDetailPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var goToCart: UIButton!
    @IBOutlet weak var productDetailCollectionView: UICollectionView!
    @IBOutlet weak var addToCart: UIButton!
    
    let kCellIdentifier =
        "ProductDetailCollectionView"
    let interItemSpacing: CGFloat = 16.0
    let lineSpacing: CGFloat = 16.0
    var productInfo: ListToDetailTransfer?
    var productId: Int?
    var userEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomeViewCell()
        productDetailCollectionView.delegate = self
        productDetailCollectionView.dataSource = self
        setButton(button: goToCart)
        setButton(button: addToCart)
    }
   
    func setButton(button: UIButton)
    {
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.black
        button.layer.borderWidth = 1.0
    }
    
    @IBAction func addToCart(_ sender: Any) {
        
            if userEmail != nil {
                guard let url = URL(string: "http://10.20.4.154:8082/cart") else {
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let body: [String: AnyHashable] = [
                    "productId" : productId,
                    "quantity": 1,
                    "emailId": userEmail
                ]
                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data,error == nil else{
                        return
                    }
                    do{
                        let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                        
                        print("Success: \(response)")
                    }
                    catch {
                        print(error)
                    }
                }
                task.resume()
            
        }
    }
    
    
    
    @IBAction func goToCart(_ sender: Any) {
        if userEmail != nil {
            if let giveDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CartViewController") as? CartViewController{
                giveDetails.userEmail = userEmail
                navigationController?.pushViewController(giveDetails, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width:UIScreen.main.bounds.width, height: 600)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = productDetailCollectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as? ProductDetailCollectionViewCell else{
            print("custom cell not being created")
            return UICollectionViewCell()
        }
        cell.productName.text = productInfo?.productName
        if let productInfovalue = productInfo, let priceValue = productInfovalue.productPrice{
            cell.productPrice.text = "Price:     Rs. \(priceValue)"
        }
        self.loadImage(urlString: productInfo?.imageUrl, imageView: cell.productImage)
        if let productInfo = productInfo, let description = productInfo.productDescription
        {
            cell.productDescription.text = "Description:  \(description)"
        }
        
        if let productInfo = productInfo, let color = productInfo.productColor{
            cell.productColor.text = "Color:        \(color)"
        }
        if let productInfo = productInfo, let weight = productInfo.productWeight{
            cell.productWeight.text = "Weight:       \(weight)"
        }
        if let productInfo = productInfo, let dimension = productInfo.productDimension{
            cell.productDimension.text = "Dimension:    \(dimension)"
        }
        return cell
    }
    
    func registerCustomeViewCell(){
        let nib = UINib(nibName: "ProductDetailCollectionViewCell", bundle: nil)
        productDetailCollectionView.register(nib, forCellWithReuseIdentifier: kCellIdentifier)
    }
    
    func loadImage(urlString: String?, imageView: UIImageView)  {
        if let unwrappedString = urlString,
           let url = URL(string: unwrappedString) {
            print(unwrappedString)
            
            DispatchQueue.global(qos: .background).async {
                do {
                    let imageData = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        let loadedImage = UIImage(data: imageData)
                        imageView.image = loadedImage
                        imageView.contentMode = .scaleAspectFit
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
