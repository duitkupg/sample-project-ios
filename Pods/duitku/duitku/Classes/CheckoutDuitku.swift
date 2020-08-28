

import UIKit
import WebKit



class CheckoutDuitku: UIViewController  {

    


    
    @IBOutlet weak var ImageLoading: UIImageView!
    @IBOutlet weak var CardLoading: UIView!
    
    @IBOutlet weak var webView: WKWebView!
    
    
    @IBOutlet weak var CardError: UIView!
    
    
    @IBOutlet weak var ImageError: UIImageView!
    
    
    @IBOutlet weak var textError: UILabel!
    
    var paymentMethod: String = ""
    var reference: String = ""

    private var duitkuKit_ = [DuitkuKit]()

    private var itemDetails_ = [ItemDetails]()

    private let helper = Helper()
    private let sandbox_ = Sandbox()
    public var num : Int = 0
    public var  isCheckTransactionDOne : Bool = false
    public var contextX : UIViewController = UIViewController()
    

    
           override func viewDidLoad() {
               super.viewDidLoad()
            
     
               webView.navigationDelegate = self
               webView.allowsBackForwardNavigationGestures = true ;
               self.navigationController!.interactivePopGestureRecognizer!.delegate = self;
                   
               helper.setLoadingDuitku(Image: ImageLoading, view: CardLoading , hidden: false)
               helper.setErrorDuitku(Image: ImageError, view: CardError , hidden: true , textError: textError , message: "")
            
            
                guard  DuitkuKit.paymentAmount != "" else {
                    self.navigationController!.setNavigationBarHidden(false, animated: true)
                    self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                    self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:   "Server Error")
                                                          
                    return
                                       
                }
            
                requestTransaction_()
            
            
           }
    
    
            override func viewDidAppear(_ animated: Bool) {
                  super.viewDidAppear(animated)
                                         
                    self.navigationController!.setNavigationBarHidden(true, animated: true)
                                
                    if (helper.isConnectedToNetwork() == false ) {
                        self.navigationController!.setNavigationBarHidden(false, animated: true)
                        self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                        self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false, textError: self.textError , message: "Internet is not connected")
                       helper.showToast(message: "Internet is not connected",context: self)
                                              
                        return
                     }
                                  
              }
    
    
        
    
    
          private func requestTransaction_(){
            
            
          
              let helper = Helper()
            
            
             if (helper.isConnectedToNetwork() == false ) {
                self.navigationController!.setNavigationBarHidden(false, animated: true)
                self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false, textError: self.textError , message: "Internet is not connected")
                helper.showToast(message: "Internet is not connected",context: self)
                                       
                 return
              }
            
              //parameter
              let parameters = helper.paramRequest(paymentMethod: self.paymentMethod)
                           
              //set url
              let url = BaseRequestDuitku.baseUrlPayment + BaseRequestDuitku.requestTransaction
          
      
              guard let serviceUrl = URL(string: url) else { return }
         
              var request = URLRequest(url: serviceUrl)
              request.httpMethod = "POST"
              request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
              guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                  return
              }
              request.httpBody = httpBody
              
              let session = URLSession.shared
              session.dataTask(with: request) { (data, response, error) in
                   DispatchQueue.main.async {
                    
                    
                    // ensure there is no error for this HTTP response
                   guard error == nil else {
                       self.navigationController!.setNavigationBarHidden(false, animated: true)
                       helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                       helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:"error: \(String(describing: error?.localizedDescription))")
                       return
                   }
                   
                   // ensure there is data returned from this HTTP response
                    guard let data = data else {
                        self.navigationController!.setNavigationBarHidden(false, animated: true)
                        helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                        helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:"Server Error \(String(describing: error?.localizedDescription))")
                        return
                    }
                   
                       // serialise the data / NSData object into Dictionary [String : Any]
                     /*guard let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                                                  
                       helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                       helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:"Server Error \(String(describing: error?.localizedDescription))")
                       
                          return
                      }*/
           
             
                      do {
                        
                         
                           let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                        
                        
                           guard let statusMessage = json["statusMessage"] as? String else {
                                 self.navigationController!.setNavigationBarHidden(false, animated: true)
                                 self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                                 self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:   "Server Error")
                                   return
                           }
                        
                        
                           guard let paymentUrl = json["paymentUrl"] as? String else {
                            
                              self.navigationController!.setNavigationBarHidden(false, animated: true)
                              self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                              self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:   statusMessage)
                            
                                return
                            
                            }
                        
                           guard let reference = json["reference"] as? String else {
                                 self.navigationController!.setNavigationBarHidden(false, animated: true)
                                 self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                                 self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:   statusMessage)
                               
                                   return
                                                   
                           }
                        
                            
                            Util.REFERENCE = reference
                                                                    
                          //Get Url PaymentUrl from json
                            let urlPayment = URL(string:paymentUrl)!
                                                
                            if(paymentUrl.contains("sandbox")){
                                Util.MODE_PAYMENT = "sandbox"
                            }else if(paymentUrl.contains("passport")){
                                 Util.MODE_PAYMENT = "passport"
                            }
                        
                            self.webView.load(URLRequest(url: urlPayment))
                        self.webView.allowsBackForwardNavigationGestures = true ;
                
                            
                            helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                         
                       
                          
                      } /*catch let error {

                        self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                        self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message: error.localizedDescription)
                      }*/
                      
                      
                      
                      
                  }
             }.resume()
      }
    
    
       public func checkTransaction(reference : String){
        
                      let helper = Helper()
                     
                      if (helper.isConnectedToNetwork() == false ) {
                         self.navigationController!.setNavigationBarHidden(false, animated: true)
                         self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                         self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false, textError: self.textError , message: "Internet is not connected")
                         helper.showToast(message: "Internet is not connected",context: self)
                                                
                          return
                       }
                     
                       //parameter
                       let parameters = helper.paramCheckTrx(reference: reference)
                                    
                       //set url
                       let url = BaseRequestDuitku.baseUrlPayment + BaseRequestDuitku.checkTransaction
                   
               
                       guard let serviceUrl = URL(string: url) else { return }
                  
                       var request = URLRequest(url: serviceUrl)
                       request.httpMethod = "POST"
                       request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                       guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                           return
                       }
                       request.httpBody = httpBody
                       
                       let session = URLSession.shared
                       session.dataTask(with: request) { (data, response, error) in
                            DispatchQueue.main.async {
                             
                             
                             // ensure there is no error for this HTTP response
                            guard error == nil else {
                             self.navigationController!.setNavigationBarHidden(false, animated: true)
                             helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                             helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:"error: \(String(describing: error?.localizedDescription))")
                                return
                            }
                            
                            // ensure there is data returned from this HTTP response
                             guard let data = data else {
                                 self.navigationController!.setNavigationBarHidden(false, animated: true)
                                 helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                                 helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:"Server Error \(String(describing: error?.localizedDescription))")
                                 return
                             }
                            
                            // serialise the data / NSData object into Dictionary [String : Any]
                            /*guard let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                                                       
                            helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                             helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:"Server Error \(String(describing: error?.localizedDescription))")
                            
                               return
                            }*/

                                                    
                      
                               do {
                                 
                                  
                                    let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                                    print(json)
                                 
                                    guard let statusMessage = json["statusMessage"] as? String else {
                                          self.navigationController!.setNavigationBarHidden(false, animated: true)
                                          self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                                          self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:   "Server Error")
                                        
                                            return
                                                            
                                    }
                                
                                    guard let reference = json["reference"] as? String else {
                                            self.navigationController!.setNavigationBarHidden(false, animated: true)
                                            self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                                            self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:   "Server Error")
                                          
                                              return
                                                                                          
                                    }
                                
                                   guard let code = json["statusCode"] as? String else {
                                           self.navigationController!.setNavigationBarHidden(false, animated: true)
                                           self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                                           self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:   "Server Error")
                                         
                                             return
                                                                                         
                                   }
                                
                                  guard let orderId = json["merchantOrderId"] as? String else {
                                             self.navigationController!.setNavigationBarHidden(false, animated: true)
                                             self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                                             self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:   "Server Error")
                                       
                                           return
                                                                                       
                                  }
                                

                                 guard let amount = json["amount"] as? String else {
                                       self.navigationController!.setNavigationBarHidden(false, animated: true)
                                       self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                                       self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:   "Server Error")
                                     
                                         return
                                                                                     
                                 }
                                
                                 // helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: false)
                                 self.modeInformation(status: statusMessage, reference: reference, amount: amount, code: code, merchantOrderId: orderId );
                                // self.navigationController?.popViewController(animated: false)
                                 //self.navigationController?.popToRootViewController(animated: true)
                                
                                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: false)
                  
                                   
                               } /*catch {

                                 self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                                 self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message: error.localizedDescription)
                               }
                               */
                               
                               
                               
                           }
                      }.resume()
            
        }
       
          
    
    
    private func overloading(url : String)  {
        
       guard url != "" else {
            self.navigationController!.setNavigationBarHidden(false, animated: true)
            self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
            self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:   "Server Error")
            return
                              
       }
        
        
       if (Util.MODE_PAYMENT.contains("sandbox")) {
            
            let act = Sandbox();
        act.runSandbox(context: self, url: url, webView: webView, reference: Util.REFERENCE , imageLoading: ImageLoading, cardLoading: CardLoading, checkoutDuitku: self)
            
        }else if (Util.MODE_PAYMENT.contains("passport")){
            let act = Passport();
              act.runPassport(context: self, url: url, webView: webView, reference: Util.REFERENCE , imageLoading: ImageLoading, cardLoading: CardLoading, checkoutDuitku: self)
            
        }
        
        
    }
    
    
        func modeInformation(status : String , reference : String , amount: String , code : String  , merchantOrderId  : String )  {
            
            self.navigationController?.popViewController(animated: true)
            DuitkuClient.amount = amount
            DuitkuClient.code = code
            DuitkuClient.reference = reference
            DuitkuClient.status = status
            DuitkuClient.merchantOrderId = merchantOrderId

        }
    
    

    
    
    
    
      
    
}





extension CheckoutDuitku: WKNavigationDelegate {
    

            
            func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
                
                //check url
                 if let url = webView.url?.absoluteString{
                      overloading(url: url)
                 }
   
            }
        
            private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError)
                       {
                          if(error.code == NSURLErrorNotConnectedToInternet)
                          {
                              
                          self.helper.setLoadingDuitku(Image: self.ImageLoading, view: self.CardLoading , hidden: true)
                          self.helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false, textError: self.textError , message: error.description)

                          }
            }
    
    
    


    
    
    
    
}


extension CheckoutDuitku:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

