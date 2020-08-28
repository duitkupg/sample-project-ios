//
//  SANDBOX.swift
//  MakeSDK
//
//  Created by Bambang Maulana on 02/07/20.
//  Copyright © 2020 Bambang Maulana. All rights reserved.
//

import Foundation
import UIKit
import WebKit

public class Sandbox  {
    
    

    func runSandbox(context : CheckoutDuitku, url : String , webView : WKWebView , reference : String , imageLoading : UIImageView , cardLoading : UIView ,checkoutDuitku :UIViewController )   {
        
              let deepLinkUrl = URL(string:url)!
              let helper = Helper()
              let checkoutDuitku =  context
              
        
              helper.setLoadingDuitku(Image: imageLoading, view: cardLoading, hidden: true)
        
              
              let vc = context.storyboard?.instantiateViewController(withIdentifier:"listPaymentDuitku") as!ListPaymentDuitku
              vc.viewWillAppear(true)
                     
               if url.contains(DuitkuKit.returnUrl) || url == "" {
                
                    helper.setLoadingDuitku(Image: imageLoading, view: cardLoading, hidden: true)
                    webView.stopLoading()
                
                    guard url == "" else {
                    let vc = context.storyboard?.instantiateViewController(withIdentifier:"listPaymentDuitku") as!ListPaymentDuitku
                    vc.viewWillAppear(true)
                                            
                      context.navigationController?.popViewController(animated: true)
                      return
                        
                    }
                                    
                    if(Util.redirect){
                        
                         if (url.contains("resultCode=01")){
            
                            checkoutDuitku.isCheckTransactionDOne = true ;
                             DuitkuClient.code = "01";
                             DuitkuClient.amount = "";
                             DuitkuClient.reference = reference;
                             DuitkuClient.status = "Pending" ;

                         }else if (url.contains("resultCode=02")){

                              checkoutDuitku.isCheckTransactionDOne = true ;
                              DuitkuClient.code = "01";
                              DuitkuClient.amount = "";
                              DuitkuClient.reference = reference;
                              DuitkuClient.status = "Pending" ;

                         }else{

                             checkoutDuitku.isCheckTransactionDOne = true ;
                             DuitkuClient.code = "404"; //code forfinish
                             DuitkuClient.amount = "";
                             DuitkuClient.reference = "";
                             DuitkuClient.status = "" ;

                         }
                        
                        context.navigationController?.popViewController(animated: true)
                        
                        return
                    }else{

                        if (url.contains("resultCode=00")){

                            checkoutDuitku.isCheckTransactionDOne = true ;
                            DuitkuClient.code = "404"; //code forfinish
                            DuitkuClient.amount = "";
                            DuitkuClient.reference = "";
                            DuitkuClient.status = "" ;

                            context.navigationController?.popViewController(animated: true)
                  
                        }else{

                            context.navigationController?.popViewController(animated: true)
                            

                        }


                    }
                
                
                    
           
                   
             
                    
                   //open in another app
                }else if url.contains("https://www.duitku.com/en/") || url.contains("www.duitku.com") || url.contains("https://www.duitku.com") || url.contains("https://duitku.com")  {
                        webView.stopLoading()
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(deepLinkUrl, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                        }
                
                   //open in another app
                }else if url.contains("https://new.permatanet.com/") || url.contains("https://new.permatanet.com") || url.contains("https://new.permatanet.com/permatanet/retail/logon") {
                        webView.stopLoading()
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(deepLinkUrl, options: [:], completionHandler: nil)

                        } else {
                           // Fallback on earlier versions
                        }
                                  
                     
                }else if url.contains("shopee.co.id") || url.contains("airpay.co.id"){
                        webView.stopLoading()
                    
                       do
                       {
                              if #available(iOS 10.0, *) {
                                  UIApplication.shared.open(deepLinkUrl, options: [:], completionHandler: nil)
                                  context.navigationController?.popViewController(animated: true)
                              } else {
                                 // Fallback on earlier versions
                              }
                                                            
                       }
                       /*catch let error
                       {
                              helper.showToast(message: "Please, download app",context: context)
                              print(error.localizedDescription)
                       }*/
                    
                     
                }else if url.contains("linkaja.id") {
                    
                        do
                        {
                               if #available(iOS 10.0, *) {
                                   
                                   UIApplication.shared.open(deepLinkUrl, options: [:], completionHandler: nil)
                                   
                               } else {
                                  // Fallback on earlier versions
                               }
                                                             
                        }/*
                        catch let error
                        {
                               helper.showToast(message: "Please, download app",context: context)
                               print(error.localizedDescription)
                        }*/
                    
                }else if url.contains("linkaja") {
                    
                    
                    
                    if url.contains("Qris") {
                        
                    }else{
                        
                        do
                        {
                               if #available(iOS 10.0, *) {
                                   UIApplication.shared.open(deepLinkUrl, options: [:], completionHandler: nil)

                               } else {
                                  // Fallback on earlier versions
                               }
                                                             
                        }/*
                        catch let error
                        {
                               helper.showToast(message: "Try Again",context: context)
                               print(error.localizedDescription)
                        }*/
                        
                    }
                    
                    
                    
                    
                }else{
                    
                    
                    
                    if url.contains("TopUp") && url.contains("Notification") {
                        
                            if(Util.merchantNotification){
                                helper.setLoadingDuitku(Image: imageLoading, view: cardLoading, hidden: false)
                                //solve double reload check transaction
                                if(checkoutDuitku.num == 0){
                                  checkoutDuitku.isCheckTransactionDOne = true ;
                                    checkoutDuitku.checkTransaction(reference: reference);
                                  checkoutDuitku.num = checkoutDuitku.num+1;
                                }
                                
                            }
                            
                            
                            if(Util.merchantNotification && checkoutDuitku.num > 0) {
                                 helper.setLoadingDuitku(Image: imageLoading, view: cardLoading, hidden: false)
                            } else{
                                  DuitkuClient.topUpNotif = "TopUp";
                                  helper.setLoadingDuitku(Image: imageLoading, view: cardLoading, hidden: true)
                                  //((DuitkuTransaction)(context)).closeToolbar();
                            }
                        
                    }
                    
                    
                    if url.contains("sandbox")  {

                          //if contain return url
                         if(url.contains(DuitkuKit.returnUrl) || url == ""  ) {
                              //wait(500);
                              helper.setLoadingDuitku(Image: imageLoading, view: cardLoading, hidden: true)
                              webView.stopLoading();
                              context.navigationController?.popViewController(animated: true)
                         }else{
                             helper.setLoadingDuitku(Image: imageLoading, view: cardLoading, hidden: false)
                             
                         }

                    } else if url.contains("TopUpOVO") {
                            //
                    }else {
                        
                            helper.setLoadingDuitku(Image: imageLoading, view: cardLoading, hidden: true)
                            
                    }
                    
                    
                              
                    
                    
                }
        
             //   helper.setLoadingDuitku(Image: imageLoading, view: cardLoading, hidden: true)
        
                if (url.contains(DuitkuKit.returnUrl)){
                 
                    helper.setLoadingDuitku(Image: imageLoading, view: cardLoading, hidden: false)
                    }else {
                      helper.setLoadingDuitku(Image: imageLoading, view: cardLoading, hidden: true)
                }
        
        
    }
    

    
    
    
    
}
