//
//  ProductListCollectionViewCell.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 26/07/22.
//

import UIKit

class ProductListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var offerPrice: UILabel!
    @IBOutlet weak var strikedPrice: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var starRatings: UILabel!
    @IBOutlet weak var ratingsDisplay: UILabel!
    
    override func prepareForReuse() {
        imageDisplay.image = UIImage(systemName: "star")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeTextStriked()
            productName.font = UIFont.boldSystemFont(ofSize: 18.0)
            offerPrice.font = UIFont.boldSystemFont(ofSize: 16.0)
            ratingsDisplay.font = UIFont.boldSystemFont(ofSize: 14.0)
        
    }
    
    func makeTextStriked()
    {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "Your String here")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        strikedPrice.attributedText = attributeString
    }
    
}
