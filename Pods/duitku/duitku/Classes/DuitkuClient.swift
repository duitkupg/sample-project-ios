//
//  tes.swift
//  MakeSDK
//
//  Created by Bambang Maulana on 07/07/20.
//  Copyright © 2020 Bambang Maulana. All rights reserved.
//

import Foundation
import UIKit

open class DuitkuClient: UIViewController {
    
       
    public static var code : String = ""
    public static var status : String  = "";
    public static var amount : String  = "";
    public static var reference  : String = "";
    public static var merchantOrderId  : String = "";
    public static var topUpNotif : String  = "";

    open func onSuccess_(status : String , reference : String , amount: String , code : String  , merchantOrderId : String ){
       
    }
    open func onPending_(status : String , reference : String , amount: String , code : String  , merchantOrderId : String){
       
    }
    open func onCanceled_(status : String , reference : String , amount: String , code : String  , merchantOrderId :String ){
       
    }
    
    func onDone(){
        
    }
    
    
    open func runPayment (context : UIViewController){
        
        if(DuitkuClient.code == "00"){
            onSuccess_(status: DuitkuClient.status, reference: DuitkuClient.reference, amount: DuitkuClient.amount, code: DuitkuClient.code , merchantOrderId: DuitkuClient.merchantOrderId)
        } else if(DuitkuClient.code == "01"){
            onPending_(status: DuitkuClient.status, reference: DuitkuClient.reference, amount: DuitkuClient.amount, code: DuitkuClient.code , merchantOrderId: DuitkuClient.merchantOrderId)
        } else if(DuitkuClient.code == "02"){
            onCanceled_(status: DuitkuClient.status, reference: DuitkuClient.reference, amount: DuitkuClient.amount, code: DuitkuClient.code , merchantOrderId: DuitkuClient.merchantOrderId)
        } else if(DuitkuClient.code == "03"){
            onCanceled_(status: DuitkuClient.status, reference: DuitkuClient.reference, amount: DuitkuClient.amount, code: DuitkuClient.code , merchantOrderId: DuitkuClient.merchantOrderId)
        }else {
            
        }
        
    }
    
    func duitkuFinish (context : UIViewController){
         
         if(DuitkuClient.code == "00"){
              onDone()
         } else if(DuitkuClient.code == "01"){
              onDone()
         } else if(DuitkuClient.code == "02"){
              onDone()
         } else if(DuitkuClient.code == "03"){
              onDone()
         } else if (DuitkuClient.code == "404") { //code done
             onDone();
             clearSdkTask();
         }else {
             
         }
         
     }
    
    func FinishTopUpNotify(context : UIViewController) {
        //CC
        if (DuitkuClient.topUpNotif == "topUp" || DuitkuClient.topUpNotif == "Notification") {
            onDone();
        }
    }
    

    open func clearSdkTask() {
           DuitkuClient.code = "";
           DuitkuClient.status = "";
           DuitkuClient.amount = "";
           DuitkuClient.reference = "";
           DuitkuClient.merchantOrderId = ""
           DuitkuClient.topUpNotif = "";
     }
    
    public func startPayment(context : UIViewController) {
  
           let storyboard = UIStoryboard.init(name: "ListPaymentDuitku", bundle: Bundle(for: ListPaymentDuitku.self))
           let vc = storyboard.instantiateViewController(withIdentifier: "listPaymentDuitku")
           context.navigationController!.pushViewController(vc,animated: true)

    }
    
    
    

}
