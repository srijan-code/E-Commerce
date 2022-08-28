//
//  ProductListPageViewController.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 26/07/22.
//

import UIKit

class ProductListPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, ProductListManagerDelegate {
    
    @IBOutlet weak var ProductListCollectionView: UICollectionView!
    @IBOutlet weak var SearchProductBar: UISearchBar!
    
    var productDataSet: [products]?
    let interItemSpacing: CGFloat = 16.0
    let lineSpacing: CGFloat = 16.0
    let kCellIdentifier = "ProductListCollectionViewCell"
    var urlCaller: ProductAPIManager?
    var sendToPageDetails: ListToDetailTransfer?
    var category: String?
    var isCategory: Bool? = false
    var searchText: String?
    var userEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomeViewCell()
        ProductListCollectionView.delegate = self
        ProductListCollectionView.dataSource = self
        SearchProductBar.delegate = self
        urlCaller = ProductAPIManager()
        urlCaller?.delegate = self
        if isCategory == true{
            urlCaller?.fetchProductList(searchItem: category ?? "")
        } else {
            urlCaller?.fetchProductListUsingSearch(searchItem: searchText ?? "")
        }
        setCell()
    }
    
    func updateData(productDetail: [products]) {
        productDataSet = productDetail
        DispatchQueue.main.async {
            self.ProductListCollectionView.reloadData()
            self.setCell()
        }
    }
    
    func setCell(){
        ProductListCollectionView.layer.cornerRadius = 50.0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        urlCaller?.fetchProductListUsingSearch(searchItem: searchBar.text ?? "")
    }
    
    func registerCustomeViewCell(){
        let nib = UINib(nibName: kCellIdentifier, bundle: nil)
        ProductListCollectionView.register(nib, forCellWithReuseIdentifier: kCellIdentifier)
    }
    
    func getStars(ratings: Int) -> (String){
        var stars: String = ""
        switch ratings{
        case 0: stars = "✩✩✩✩✩"
        case 1: stars = "★✩✩✩✩"
        case 2: stars = "★★✩✩✩"
        case 3: stars = "★★★✩✩"
        case 4: stars = "★★★★✩"
        case 5: stars = "★★★★★"
        default: stars = ""
        }
        return stars
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width:UIScreen.main.bounds.width, height: 180)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDataSet?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let giveDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProductDetailPageViewController") as? ProductDetailPageViewController{
            sendToPageDetails = ListToDetailTransfer()
            sendToPageDetails?.productName = productDataSet?[indexPath.row].name
            sendToPageDetails?.imageUrl = productDataSet?[indexPath.row].imageUrl
            sendToPageDetails?.productDescription = productDataSet?[indexPath.row].description
            sendToPageDetails?.productPrice = productDataSet?[indexPath.row].price
            sendToPageDetails?.productColor = productDataSet?[indexPath.row].color
            sendToPageDetails?.productWeight = productDataSet?[indexPath.row].weight
            sendToPageDetails?.productDimension = productDataSet?[indexPath.row].dimension
            giveDetails.productInfo = sendToPageDetails
            giveDetails.productId = productDataSet?[indexPath.row].id
            giveDetails.userEmail = userEmail
            navigationController?.pushViewController(giveDetails, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = ProductListCollectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as? ProductListCollectionViewCell else{
            print("custom cell not being created")
            return UICollectionViewCell()
        }
        self.loadImage(urlString: productDataSet?[indexPath.row].imageUrl, imageView: cell.imageDisplay)
        cell.productName.text = productDataSet?[indexPath.row].name
        if let priceData = productDataSet?[indexPath.row], let price = priceData.price{
            cell.offerPrice.text = "Rs. \(price)"
        }
        if let strikeData = productDataSet?[indexPath.row], let price = strikeData.price{
            cell.strikedPrice.text = "Rs. \(price)"
        }
        cell.starRatings.text = getStars(ratings: Int(productDataSet?[indexPath.row].rating ?? 0))
        if let ratingDisplay = productDataSet?[indexPath.row], let rating = ratingDisplay.rating{
            cell.ratingsDisplay.text = "\(rating)"
        }
        return cell
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


