//
//  OrderCollectionViewCell.swift
//  E-Commerce
//
//  Created by Srijan Kumar  on 01/08/22.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var productsBought: UILabel!
    @IBOutlet weak var boughtStatic: UILabel!
    @IBOutlet weak var dateOfBuying: UILabel!
    
    @IBOutlet weak var greetingStatic: UILabel!
    @IBOutlet weak var amountTotal: UILabel!
    @IBOutlet weak var amountStatic: UILabel!
    @IBOutlet weak var dateStatic: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var orderStatic: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
