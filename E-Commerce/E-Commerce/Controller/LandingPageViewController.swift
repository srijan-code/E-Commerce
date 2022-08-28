//
//  LandingPageViewController.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 26/07/22.
//

import UIKit

class LandingPageViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecommendationManagerDelegate {
    
    @IBOutlet weak var wardrobe: UIButton!
    @IBOutlet weak var bed: UIButton!
    @IBOutlet weak var sofa: UIButton!
    @IBOutlet weak var chair: UIButton!
    @IBOutlet weak var tables: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var recommendationCollectionView: UICollectionView!
    
    var productDataSet: [products]?
    let interItemSpacing: CGFloat = 16.0
    let lineSpacing: CGFloat = 16.0
    var urlCaller: RecommendationAPIManager?
    var sendToPageDetails: ListToDetailTransfer?
    let kCellIdentifier  = "RecommendationCollectionViewCell"
    let layout = UICollectionViewFlowLayout()
    var userEmail: String? 
    
    @IBAction func cartButton(_ sender: Any) {
        if userEmail != nil {
            if let giveDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CartViewController") as? CartViewController{
                giveDetails.userEmail = userEmail
                navigationController?.pushViewController(giveDetails, animated: true)
            }
        }
    }
    @IBAction func LoginButton(_ sender: Any) {
        if userEmail == nil{
        if let giveDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginPageController") as? LoginPageController{
            navigationController?.pushViewController(giveDetails, animated: true)
        }
        } else {
            userEmail = nil
            LoginButton.setTitle("Login", for: .normal)
        }
    }
    
    @IBAction func wardrobe(_ sender: Any) {
        callAPI(category: "wardrobes")
    }
    
    @IBAction func chair(_ sender: Any) {
        callAPI(category: "chairs")
    }
    
    @IBAction func bed(_ sender: Any) {
        callAPI(category: "beds")
    }
    
    @IBAction func sofa(_ sender: Any) {
        callAPI(category: "sofas")
    }
    
    @IBAction func tables(_ sender: Any) {
        callAPI(category: "tables")
    }
    
    func callAPI(category: String)
    {
        if let giveDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProductListPageViewController") as? ProductListPageViewController{
            giveDetails.category = category
            giveDetails.isCategory = true
            giveDetails.userEmail = userEmail
            navigationController?.pushViewController(giveDetails, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDataSet?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = recommendationCollectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as? RecommendationCollectionViewCell else{
            print("custom cell not being created")
            return UICollectionViewCell()
        }
        //cell.contentView.backgroundColor = .cyan
        self.loadImage(urlString: productDataSet?[indexPath.row].imageUrl, imageView: cell.productImage)
        cell.productName.text = productDataSet?[indexPath.row].name
        if let priceData = productDataSet?[indexPath.row], let price = priceData.price{
            cell.productPrice.text = "Rs. \(price)"
        }
        if let strikeData = productDataSet?[indexPath.row], let price = strikeData.price{
            cell.productStrikedPrice.text = "Rs. \(price)"
        }
        cell.productStarRatings.text = getStars(ratings: Int(productDataSet?[indexPath.row].rating ?? 0))
        if let ratingDisplay = productDataSet?[indexPath.row], let rating = ratingDisplay.rating{
            cell.productRatings.text = "\(rating)"
        }
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20.0
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProductDetailPageViewController") as? ProductDetailPageViewController,
              let currentProductSet = productDataSet?[indexPath.row] else {
            return
        }
        detailViewController.productInfo = currentProductSet.listViewDetail
        detailViewController.productId = currentProductSet.id
        detailViewController.userEmail = userEmail
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        SearchBar.delegate = self
        setButtonProperties()
        registerCustomeViewCell()
        recommendationCollectionView.delegate = self
        recommendationCollectionView.dataSource = self
        SearchBar.delegate = self
        urlCaller = RecommendationAPIManager()
        urlCaller?.delegate = self
        urlCaller?.fetchProductList(searchItem: "")
        layout.scrollDirection = .horizontal
        self.recommendationCollectionView.collectionViewLayout = layout
        setButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        toggleStatus()
    }
    func toggleStatus()
    {
        if userEmail != nil
        {
            LoginButton.setTitle("LogOut", for: .normal)
        }
    }
    
    
    func buttonProperty(button: UIButton)
    {
        button.layer.cornerRadius = 0.5 * button.bounds.size.height
        button.clipsToBounds = true
    }
    
    func setButton()
    {
        buttonProperty(button: wardrobe)
        buttonProperty(button: chair)
        buttonProperty(button: bed)
        buttonProperty(button: sofa)
        buttonProperty(button: tables)
    }
    func updateData(productDetail: [products]) {
        productDataSet = productDetail
        DispatchQueue.main.async {
            self.recommendationCollectionView.reloadData()
        }
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
    
    func setButtonProperties()
    {
        LoginButton.layer.cornerRadius = 5
        LoginButton.layer.borderColor = UIColor.black.cgColor
        LoginButton.layer.borderWidth = 1.0
    }
    
    func registerCustomeViewCell(){
        let nib = UINib(nibName: kCellIdentifier, bundle: nil)
        recommendationCollectionView.register(nib, forCellWithReuseIdentifier: kCellIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width:UIScreen.main.bounds.width, height: 200)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let giveDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProductListPageViewController") as? ProductListPageViewController{
            giveDetails.searchText = searchBar.text
            giveDetails.userEmail = userEmail
            navigationController?.pushViewController(giveDetails, animated: true)
        }
    }
}
