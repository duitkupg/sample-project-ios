//
//  listPayment.swift
//  MakeSDK
//
//  Created by Bambang Maulana on 31/03/20.
//  Copyright © 2020 Bambang Maulana. All rights reserved.
//

class listPayment{


    var paymentMethod:String
    var paymentName:String
    var paymentImage:String
    var totalFee:String
    
    init (_ paymentMethod:String, _ paymentName:String , _ paymentImage:String, _ totalFee:String){
        
        self.paymentMethod = paymentMethod
        self.paymentName = paymentName
        self.paymentImage = paymentImage
        self.totalFee = totalFee
        
    }
    
    
    

}


