//
//  DuitkuKit.swift
//  MakeSDK
//
//  Created by Bambang Maulana on 07/04/20.
//  Copyright © 2020 Bambang Maulana. All rights reserved.
//

public class DuitkuKit {
    
    

    public static var paymentAmount: String = ""
    public static var productDetails: String = ""
    public static var email: String = ""
    public static var phoneNumber: String = ""
    public static var additionalParam: String = ""
    public static var merchantUserInfo: String = ""
    public static var customerVaName: String = ""
    public static var callbackUrl: String = ""
    public static var returnUrl: String = ""
    public static var expiryPeriod: String = ""
    public static var merchantOrderId: String = ""
    
    //customerDetail
    public static var firstName: String = ""
    public static var lastName: String = ""
     
    //address
    public static var alamat: String = ""
    public static var city: String = ""
    public static var postalCode: String = ""
    public static var countryCode: String = ""

    
    public static func data(paymentAmount: String , productDetails: String , email: String , phoneNumber: String ,additionalParam: String ,  merchantUserInfo: String , customerVaName: String ,  callbackUrl: String , returnUrl: String , expiryPeriod: String , firstName: String ,  lastName: String , alamat: String , city: String , postalCode: String ,  countryCode: String ,  merchantOrderId: String     ) {
        
        self.paymentAmount = paymentAmount
        self.productDetails = productDetails
        self.email = email
        self.phoneNumber = phoneNumber
        self.additionalParam = additionalParam
        self.merchantUserInfo = merchantUserInfo
        self.customerVaName = customerVaName
        self.callbackUrl = callbackUrl
        self.returnUrl = returnUrl
        self.expiryPeriod = expiryPeriod
        self.firstName = firstName
        self.lastName = lastName
        self.alamat = alamat
        self.city = city
        self.postalCode = postalCode
        self.countryCode = countryCode
        self.merchantOrderId = merchantOrderId
              
    }

}



public class ItemDetails {
    
     public static var name: String = ""
     public static var price: Int = 0
     public static var quantity: Int = 0

    public static func data(name : String , price: Int , quantity: Int) {
        ItemDetails.self.name = name
        ItemDetails.self.price = price
        ItemDetails.self.quantity = quantity
       
    }
    
    func convertToDictionary() -> [String : Any] {
        let dic: [String: Any] = ["name":ItemDetails.self.name, "price":ItemDetails.self.price , "quantity":ItemDetails.self.quantity]
           return dic
    }
}



public class BaseRequestDuitku {
    
    public static var requestTransaction: String = ""
    public static var checkTransaction: String = ""
    public static var listPayment: String = ""
    public static var baseUrlPayment: String = ""
    public static var request_ = [BaseRequestDuitku]()

    public static func data(baseUrlPayment: String ,requestTransaction : String , checkTransaction: String , listPayment: String)  {
        BaseRequestDuitku.self.requestTransaction = requestTransaction
        BaseRequestDuitku.self.checkTransaction = checkTransaction
        BaseRequestDuitku.self.listPayment = listPayment
        BaseRequestDuitku.self.baseUrlPayment = baseUrlPayment
    }
    
    func convertToDictionary() -> [String : Any] {
        let dic: [String: Any] = ["requestTransaction":BaseRequestDuitku.self.requestTransaction, "checkTransaction":BaseRequestDuitku.self.checkTransaction , "listPayment":BaseRequestDuitku.self.listPayment,"baseUrlPayment":BaseRequestDuitku.self.baseUrlPayment]
           return dic
    }
    
}

public class itemsKit {
    
    public static var itemDetail = [ItemDetails]()
    public static var  duitku = [DuitkuKit]()
    
}


public class Util {
    
    public static var redirect: Bool = false
    public static  var merchantNotification: Bool = false
    public static  var MODE_PAYMENT: String = ""
    public static  var REFERENCE: String = ""
 
}

public class UtilDuitku {
    
    public static var isFinished: Bool = false

 
}
