//
//  CartViewController.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 28/07/22.
//

import UIKit

class CartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, CartManagerDelegate {
    
    @IBOutlet weak var cartCollectionView: UICollectionView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var paymentButton: UIButton!
    
    var cartDataSet: [Cart]?
    let interItemSpacing: CGFloat = 16.0
    let lineSpacing: CGFloat = 16.0
    let kCellIdentifier = "CartCollectionViewCell"
    var urlCaller: CartAPIManager?
    var userEmail: String?
    var toBePaid: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomeViewCell()
        cartCollectionView.delegate = self
        cartCollectionView.dataSource = self
        urlCaller = CartAPIManager()
        urlCaller?.delegate = self
        urlCaller?.fetchProductList(userEmail: userEmail ?? "")
        setButton(button: paymentButton)
    }
    func setButton(button: UIButton)
    {
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.black
        button.layer.borderWidth = 1.0
    }
    @IBAction func paymentButton(_ sender: Any) {
        if toBePaid == 0.0
        {
            DispatchQueue.main.async {
            let alert = UIAlertController(title: "Order Alert", message: "You Don't Have Items In Cart", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        } else {
        guard let url = URL(string: "http://10.20.4.154:8082/order") else {
            return
        }
        let cartData = SendDetails(cartList: cartDataSet, mailId: userEmail)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(cartData)
        } catch {
            print(error.localizedDescription)
        }
        
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
        goToOrder()
        }
    }
    
    func updateData(cartDetail: [Cart]) {
        cartDataSet = cartDetail
        DispatchQueue.main.async {
            self.cartCollectionView.reloadData()
            self.toBePaid = 0
            self.calculateTotal()
            self.totalAmount.text = "Rs. \(self.toBePaid)"
        }
    }
    
    func calculateTotal()
    {
        var totalItems: Int? = 0
        if let cartDataSet = cartDataSet{
        for items in cartDataSet{
            totalItems = items.quantity
            if let product = items.product, let price = product.price
            {
                if let totalItems = totalItems{
                    toBePaid = toBePaid + (Double(totalItems)*price)
                }
                
            }
            
        }
        }
    }
    
    func registerCustomeViewCell(){
        let nib = UINib(nibName: kCellIdentifier, bundle: nil)
        cartCollectionView.register(nib, forCellWithReuseIdentifier: kCellIdentifier)
    }
    
    func goToOrder()
    {
        if let giveDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "OrderPageViewController") as? OrderPageViewController{
            giveDetails.userEmail = userEmail
            navigationController?.pushViewController(giveDetails, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartDataSet?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = cartCollectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as? CartCollectionViewCell else{
            print("custom cell not being created")
            return UICollectionViewCell()
        }
        self.loadImage(urlString: cartDataSet?[indexPath.row].product?.imageUrl, imageView: cell.productImage)
        
        if let cartData = cartDataSet?[indexPath.row], let quantity = cartData.quantity{
            cell.quantityLabel.text = "\(quantity)"
        }
        
        cell.incrementCartHandler = { [weak self] in
            let maximumQuantity = self?.cartDataSet?[indexPath.row].product?.quantity
            var currentQuantity = self?.cartDataSet?[indexPath.row].quantity
            if currentQuantity ?? 0 <= maximumQuantity ?? 0 {                
                let id = self?.cartDataSet?[indexPath.row].id ?? ""
                guard let url = URL(string: "http://10.20.4.154:8082/cart/add/\(id)") else {
                    print("Error: cannot create URL")
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard error == nil else {
                        print("Error: error calling DELETE")
                        print(error!)
                        return
                    }
                    guard let data = data else {
                        print("Error: Did not receive data")
                        return
                    }
                    guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                        print("Error: HTTP request failed")
                        return
                    }
                    do {
                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            print("Error: Cannot convert data to JSON")
                            return
                        }
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        print(prettyPrintedJson)
                    } catch {
                        print("Error: Trying to convert JSON data to string")
                        return
                    }
                }.resume()
                self?.urlCaller?.fetchProductList(userEmail: self?.userEmail ?? "")
                currentQuantity = self?.cartDataSet?[indexPath.row].quantity
            } else {
                DispatchQueue.main.async {
                    
                let alert = UIAlertController(title: "Cart Alert", message: "Maximum Limit Reached", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        cell.decrementCartHandler = { [weak self] in
            var currentQuantity = self?.cartDataSet?[indexPath.row].quantity
            if currentQuantity ?? 0 > 0{
                
                let id = self?.cartDataSet?[indexPath.row].id ?? ""
                guard let url = URL(string: "http://10.20.4.154:8082/cart/sub/\(id)") else {
                    print("Error: cannot create URL")
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard error == nil else {
                        print("Error: error calling DELETE")
                        print(error!)
                        return
                    }
                    guard let data = data else {
                        print("Error: Did not receive data")
                        return
                    }
                    guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                        print("Error: HTTP request failed")
                        return
                    }
                    do {
                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            print("Error: Cannot convert data to JSON")
                            return
                        }
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        print(prettyPrintedJson)
                    } catch {
                        print("Error: Trying to convert JSON data to string")
                        return
                    }
                }.resume()
                self?.urlCaller?.fetchProductList(userEmail: self?.userEmail ?? "")
                currentQuantity = self?.cartDataSet?[indexPath.row].quantity
            } else {
                DispatchQueue.main.async {
                    
                let alert = UIAlertController(title: "Cart Alert", message: "Product Sold Out", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
        cell.productName.text = cartDataSet?[indexPath.row].product?.name
        if let cartData = cartDataSet?[indexPath.row], let product = cartData.product{
            if let price = product.price{
                cell.productPrice.text = "Buy At: Rs. \(price)"
            }
        }
        
        cell.removeFromCartHandler = { [weak self] in
            removeFromCart()
            self?.urlCaller?.fetchProductList(userEmail: self?.userEmail ?? "")
        }
        
        func removeFromCart()
        {
            let id = cartDataSet?[indexPath.row].id ?? ""
            guard let url = URL(string: "http://10.20.4.154:8082/cart/\(id)") else {
                print("Error: cannot create URL")
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling DELETE")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    return
                }
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width:UIScreen.main.bounds.width, height: 150)
        return cellSize
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
