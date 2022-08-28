//
//  RecommendationCollectionViewCell.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 29/07/22.
//

import UIKit

class RecommendationCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productStrikedPrice: UILabel!
    @IBOutlet weak var productStarRatings: UILabel!
    @IBOutlet weak var productRatings: UILabel!
    @IBOutlet weak var displayButton: UIButton!
    
    @IBAction func displayButton(_ sender: Any) {
    }
    override func prepareForReuse() {
        productImage.image = UIImage(systemName: "star")
    }
    
        override func awakeFromNib() {
        super.awakeFromNib()
            productName.font = UIFont.boldSystemFont(ofSize: 18.0)
            productPrice.font = UIFont.boldSystemFont(ofSize: 14.0)
            productRatings.font = UIFont.boldSystemFont(ofSize: 12.0)
        makeTextStriked()
    }
    func makeTextStriked()
    {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "Your String here")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        productStrikedPrice.attributedText = attributeString
    }
}
