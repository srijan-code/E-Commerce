//
//  OrderPageViewController.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 01/08/22.
//

import UIKit

class OrderPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, OrderManagerDelegate {
    
    @IBOutlet weak var orderCollectionView: UICollectionView!
    
    var userEmail: String?
    let kCellIdentifier = "OrderCollectionViewCell"
    var orderDataSet: [Order]?
    let interItemSpacing: CGFloat = 16.0
    let lineSpacing: CGFloat = 16.0
    var urlCaller: OrderAPIManager?
    var allProducts: String = ""
    var productNameList  : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomeViewCell()
        orderCollectionView.delegate = self
        orderCollectionView.dataSource = self
        urlCaller = OrderAPIManager()
        urlCaller?.delegate = self
        urlCaller?.fetchProductList(userEmail: userEmail ?? "")
    }
    
    func updateData(orderDetail: [Order]) {
        orderDataSet = orderDetail
        DispatchQueue.main.async {
            self.orderCollectionView.reloadData()
            self.productsName()
        }
    }
    
    
    func productsName()
    {
        
        if let _orderdataSet = orderDataSet{
            for items in _orderdataSet {
                if let cartListItems = items.cartList{
                    for cartItems in cartListItems{
                        if let product = cartItems.product
                        {
                            if let name = product.name
                            {
                                allProducts = allProducts + name + " "
                            }
                        }
                    }
                    productNameList.append(allProducts)
                    allProducts = ""
                }
                
            }
        }
        print("all products: \(allProducts)")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderDataSet?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = orderCollectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as? OrderCollectionViewCell else{
            print("custom cell not being created")
            return UICollectionViewCell()
        }
        
        cell.productsBought.text = productNameList[indexPath.row]
        if let orderDataSet = orderDataSet, let price = orderDataSet[indexPath.row].price
        {
            cell.amountTotal.text = "\(price)"
        }
        cell.orderId.text = orderDataSet?[indexPath.row].id
        cell.dateOfBuying.text = orderDataSet?[indexPath.row].date
        cell.backgroundColor = UIColor.systemYellow
        return cell
    }
    
    func registerCustomeViewCell(){
        let nib = UINib(nibName: kCellIdentifier, bundle: nil)
        orderCollectionView.register(nib, forCellWithReuseIdentifier: kCellIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: UIScreen.main.bounds.width, height: 250)
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
