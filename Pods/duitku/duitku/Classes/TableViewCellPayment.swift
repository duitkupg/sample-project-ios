//
//  TableViewCellPayment.swift
//  MakeSDK
//
//  Created by Bambang Maulana on 31/03/20.
//  Copyright © 2020 Bambang Maulana. All rights reserved.
//

import UIKit


class TableViewCellPayment: UITableViewCell {

    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelPayment: UILabel!
    @IBOutlet weak var cardCell: UIView!
    
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var imageUrl: UIImageView!
    
    var lisPayment_:listPayment!
    
    
    func setListPayment(_ lisPayment_:listPayment){
        
        Helper.setCardViewShadow(cardItem: cardCell)
        self.lisPayment_ = lisPayment_
        labelPayment.text = lisPayment_.paymentName
        labelPrice.text = "Bayar dengan "+lisPayment_.paymentName
        labelDetail.text = "Biaya Rp "+lisPayment_.totalFee.convertDoubleToCurrency().replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ".00", with: "")
        let url = URL(string: lisPayment_.paymentImage)
        self.imageUrl.downloadImage(from: url!)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}



extension UIImageView {
   func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
      URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
   }
   func downloadImage(from url: URL) {
      getData(from: url) {
         data, response, error in
         guard let data = data, error == nil else {
            return
         }
         DispatchQueue.main.async() {
            self.image = UIImage(data: data)
         }
      }
   }
}


