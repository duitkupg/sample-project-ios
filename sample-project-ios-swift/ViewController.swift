//
//  ViewController.swift
//  sample-project-ios-swift
//
//  Created by Bambang Maulana on 28/08/20.
//  Copyright © 2020 Bambang Maulana. All rights reserved.
//

import UIKit
import duitku

class ViewController: DuitkuClient{

    @IBOutlet weak var textamount: UITextField!
    @IBOutlet weak var textdetail: UITextField!
    @IBOutlet weak var textphone: UITextField!
    @IBOutlet weak var textemail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
     override func viewWillAppear(_ animated: Bool) {
            runPayment(context: self)
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.title = "sample-project"
            
      }
      
      
      override func onSuccess_(status: String, reference: String, amount: String, code: String, merchantOrderId: String) {
          self.navigationController?.popViewController(animated: false)
          clearSdkTask()
          
      }
    
    
    
    @IBAction func btn_pay(_ sender: UIButton) {
        
        
       let refreshAlert = UIAlertController(title: "Purchase", message: "Lanjut Pembayaran", preferredStyle: UIAlertController.Style.alert)

       refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
    
           self.settingMerchant()
           self.startPayment(context: self)
           
       }))

       refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
       }))

       present(refreshAlert, animated: true, completion: nil)
        
        
    }
    
      override func onPending_(status: String, reference: String, amount: String, code: String, merchantOrderId: String) {

          
           self.navigationController?.popViewController(animated: false)
          clearSdkTask()
      }
      
      override func onCanceled_(status: String, reference: String, amount: String, code: String, merchantOrderId: String) {
      
           self.navigationController?.popViewController(animated: false)
          clearSdkTask()
      }
    
    
    
    func settingMerchant(){
                
        Util.merchantNotification = true
        Util.redirect = false
        
        
        DuitkuKit.data(
            paymentAmount: textamount.text!
            ,productDetails: textdetail.text!
            ,email: textemail.text!
            ,phoneNumber: textphone.text!
             ,additionalParam: ""
             ,merchantUserInfo: ""
             ,customerVaName: ""
             ,callbackUrl: "http://merchant-server.com/callback"
             ,returnUrl: "http://merchant-server.com/return"
             ,expiryPeriod: "10"
             ,firstName: ""
             ,lastName: ""
             ,alamat: ""
             ,city: ""
             ,postalCode: ""
             ,countryCode: ""
             ,merchantOrderId: "" //can empty if merchant order id on web server
        )
        
        //star loop here
        ItemDetails.data(name: textamount.text!, price: Int(textamount.text!)!, quantity: Int("1")!) //optional
        //finish start loop
         
         // base url
        BaseRequestDuitku.data(
              baseUrlPayment: "http://merchant-server.com/sdkserver/api/sandbox/request/"
             ,requestTransaction: "transaksi"
             ,checkTransaction: "checktransaksi"
             ,listPayment: "listPayment"
         )
               

         
        
    }


}

