//
//  CartCollectionViewCell.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 28/07/22.
//

import UIKit

class CartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var removeFromCart: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var incrementCartHandler: (() -> Void)?
    var decrementCartHandler: (() -> Void)?
    var removeFromCartHandler: (() -> Void)?
    
    override func prepareForReuse() {
        productImage.image = UIImage(systemName: "star")
    }
    
    @IBAction func addButton(_ sender: Any) {
        incrementCartHandler?()
    }
    
    @IBAction func minusButton(_ sender: Any) {
        decrementCartHandler?()
    }
    
    @IBAction func removeFromCart(_ sender: Any) {
        removeFromCartHandler?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productName.font = UIFont.boldSystemFont(ofSize: 18.0)
        productPrice.font = UIFont.boldSystemFont(ofSize: 16.0)
        
    }
    
}
