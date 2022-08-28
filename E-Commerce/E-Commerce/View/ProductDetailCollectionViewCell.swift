//
//  ProductDetailCollectionViewCell.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 28/07/22.
//

import UIKit

class ProductDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productDimension: UILabel!
    @IBOutlet weak var productWeight: UILabel!
    @IBOutlet weak var productColor: UILabel!
    
    override func prepareForReuse() {
        productImage.image = UIImage(systemName: "star")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        productName.font = UIFont.boldSystemFont(ofSize: 18.0)
        productPrice.font = UIFont.boldSystemFont(ofSize: 16.0)
        productDescription.font = UIFont.boldSystemFont(ofSize: 14.0)
        productWeight.font = UIFont.boldSystemFont(ofSize: 15.0)
        productColor.font = UIFont.boldSystemFont(ofSize: 15.0)
        productDimension.font = UIFont.boldSystemFont(ofSize: 15.0)
    }
    
}
