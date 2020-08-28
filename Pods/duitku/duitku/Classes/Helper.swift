//
//  Helper.swift
//  MakeSDK
//
//  Created by Bambang Maulana on 31/03/20.
//  Copyright © 2020 Bambang Maulana. All rights reserved.
//

import UIKit
import SystemConfiguration

class Helper {

    
    let alert = UIAlertController(title: nil, message: "⏳ Memuat..", preferredStyle: .alert)
    
    //Check Connection
    func isConnectedToNetwork() -> Bool {

           var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
           zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
           zeroAddress.sin_family = sa_family_t(AF_INET)

           let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
               $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                   SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
               }
           }

           var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
           if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
               return false
           }


           // Working for Cellular and WIFI
           let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
           let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
           let ret = (isReachable && !needsConnection)

           return ret

       }
    
    
    //show progress loading
    func showLoadingDialog(show : Bool , controller : UIViewController) {
                 if show {
                     let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                     loadingIndicator.hidesWhenStopped = true
                    if #available(iOS 13.0, *) {
                       // loadingIndicator.activityIndicatorViewStyle = .medium
                    } else {
                        // Fallback on earlier versions
                    }
                     loadingIndicator.startAnimating()
                     alert.view.addSubview(loadingIndicator)
                     controller.present(alert, animated: true, completion: nil)
                 } else {
                     alert.dismiss(animated: true, completion: nil)
                 }
    }
    
    
    func paramRequest(paymentMethod:String) -> [String : Any] {
         
    let itemDetails = itemsKit.itemDetail.map { $0.convertToDictionary()}
    
                  let parameters =
                    ["paymentAmount":DuitkuKit.paymentAmount,
                                "paymentMethod":paymentMethod,
                                "productDetails":DuitkuKit.productDetails,
                                "email":DuitkuKit.email,
                                "phoneNumber":DuitkuKit.phoneNumber,
                                "additionalParam":DuitkuKit.additionalParam,
                                "merchantUserInfo":DuitkuKit.merchantUserInfo,
                                "customerVaName":DuitkuKit.customerVaName,
                                "merchantOrderId":DuitkuKit.merchantOrderId,
                                "callbackUrl":DuitkuKit.callbackUrl,
                                "returnUrl":DuitkuKit.returnUrl,
                                "expiryPeriod":DuitkuKit.expiryPeriod,
                                "itemDetails":itemDetails,
                                "customerDetail":[
                                                     "firstName": DuitkuKit.firstName,
                                                     "lastName": DuitkuKit.lastName,
                                                     "email": DuitkuKit.email,
                                                     "phoneNumber": DuitkuKit.phoneNumber,
                                                     "billingAddress": [
                                                         "firstName": DuitkuKit.firstName,
                                                         "lastName": DuitkuKit.lastName,
                                                         "address": DuitkuKit.alamat,
                                                         "city": DuitkuKit.city,
                                                         "postalCode": DuitkuKit.postalCode,
                                                         "phone": DuitkuKit.phoneNumber,
                                                         "countryCode": DuitkuKit.countryCode
                                                     ],
                                                     "shippingAddress": [
                                                        "firstName": DuitkuKit.firstName,
                                                        "lastName": DuitkuKit.lastName,
                                                        "address": DuitkuKit.alamat,
                                                        "city": DuitkuKit.city,
                                                        "postalCode": DuitkuKit.postalCode,
                                                        "phone": DuitkuKit.phoneNumber,
                                                        "countryCode": DuitkuKit.countryCode
                                                     ]
                                 
                                 ]
           ] as [String : Any]
        

                
        return parameters
    }

    
    func paramListpayment() -> [String : Any]  {
     
       let parameters = ["paymentAmount":DuitkuKit.paymentAmount]
         
         return parameters
     }
    
    
    func paramCheckTrx(reference : String) -> [String : Any]  {
      let parameters = ["reference":reference]
        
        return parameters
    }
    
        
    func setLoadingDuitku(Image:UIImageView, view:UIView , hidden:Bool){
        Image.loadGifDuitku(asset: "loadingduitku",myclass: Helper.self)
        view.isHidden = hidden
    }
    
    func setErrorDuitku(Image:UIImageView, view:UIView , hidden:Bool , textError : UILabel , message : String){
        
        
        Image.loadGifDuitku(asset: "error",myclass: Helper.self)
        view.isHidden = hidden
        textError.text = message
    }
    
    func localizedString(forKey key: String) -> String {
        var result = Bundle.main.localizedString(forKey: key, value: nil, table: nil)

        if result == key {
            result = Bundle.main.localizedString(forKey: key, value: nil, table: "stringRepo")
        }

        return result
    }
    

    func showToast(message : String, context: UIViewController) {
        
      
        let alertbox = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertbox.addAction(okAction)
        context.present(alertbox, animated: true, completion: nil)
        
       
    }
       
    
       
    
    //set Shadow (Card View)
    public static func setCardViewShadow(cardItem:UIView){
       
       cardItem.layer.shadowColor = UIColor.black.cgColor
       cardItem.layer.shadowOpacity = 0.07
       cardItem.layer.shadowOffset = .zero
       cardItem.layer.shadowRadius = 10
       
       
    }
    
    

    
    





}

