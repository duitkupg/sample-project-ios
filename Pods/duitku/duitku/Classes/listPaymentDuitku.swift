//
//  ViewController.swift
//  MakeSDK
//
//  Created by Bambang Maulana on 31/03/20.
//  Copyright © 2020 Bambang Maulana. All rights reserved.
//

import UIKit






public class ListPaymentDuitku: UIViewController  {


    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var CardLoading: UIView!
    
    @IBOutlet weak var textError: UILabel!
    
    @IBOutlet weak var LoadingDuitku: UIImageView!
     
    @IBOutlet weak var tablePayment: UITableView!

  
    @IBOutlet weak var CardError: UIView!
    
    @IBOutlet weak var ImageError: UIImageView!
    
    

    private var  listPayment_ = [listPayment]()
    
    private let helper = Helper()
    private var BaseRequest = [BaseRequestDuitku]()
    



    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        UtilDuitku.isFinished = false
        
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationItem.title = "Choose your payment"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        helper.setLoadingDuitku(Image: LoadingDuitku, view: CardLoading , hidden: false)
        helper.setErrorDuitku(Image: ImageError, view: CardError , hidden: true, textError: self.textError , message: "Server Error")
        
                     
       if (helper.isConnectedToNetwork() == false ) {
           helper.setLoadingDuitku(Image: LoadingDuitku, view: CardLoading , hidden: true)
           helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false, textError: self.textError , message: "Internet is not connected")
           helper.showToast(message: "Internet is not connected",context: self)
           return
        }
        
        guard DuitkuKit.paymentAmount != "" else {
            helper.setLoadingDuitku(Image: LoadingDuitku, view: CardLoading , hidden: true)
            helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false, textError: self.textError , message: "Server Error")
            helper.showToast(message: "Server Error",context: self)
            return
        }
        
        let amount : Int = Int(DuitkuKit.paymentAmount)!
        let amount_: Double = Double(amount)
       
        total.text =  "Rp "+String(amount_).convertDoubleToCurrency().replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ".00", with: "")
        
              
        
        setStyleTablePayment()
        loadLisPayment()
        

    }
    
    public override func viewWillAppear(_ animated: Bool) {
        
       self.navigationController?.isNavigationBarHidden = false
        
       let duitku = DuitkuClient()
       duitku.duitkuFinish(context: self)
        
       if(Util.redirect && UtilDuitku.isFinished){
            helper.setLoadingDuitku(Image: LoadingDuitku, view: CardLoading , hidden: false)
            self.navigationController?.popViewController(animated: false)
            print("Util.redirect\(Util.redirect)")
            //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
       }
    }
    
 private func loadLisPayment(){
    
          if (helper.isConnectedToNetwork() == false ) {
             helper.setLoadingDuitku(Image: LoadingDuitku, view: CardLoading , hidden: true)
             helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false, textError: self.textError , message: "Internet is not connected")
             helper.showToast(message: "Internet is not connected",context: self)
             return
          }
           
              
           let helper = Helper()
           let parameters = helper.paramListpayment()
           let url = BaseRequestDuitku.baseUrlPayment + BaseRequestDuitku.listPayment
          
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
                        
                        helper.setLoadingDuitku(Image: self.LoadingDuitku, view: self.CardLoading , hidden: true)
                        helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:"error: \(String(describing: error?.localizedDescription))")
                        return
                    }
                    
                    // ensure there is data returned from this HTTP response
                     guard let data = data else {
                           helper.setLoadingDuitku(Image: self.LoadingDuitku, view: self.CardLoading , hidden: true)
                        helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:"Server Error \(String(describing: error?.localizedDescription))")
                         return
                     }
                    
                    // serialise the data / NSData object into Dictionary [String : Any]
                    guard ((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any]) != nil else {
                                                   
                        helper.setLoadingDuitku(Image: self.LoadingDuitku, view: self.CardLoading , hidden: true)
                        helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message:"Server Error \(String(describing: error?.localizedDescription))")
                        
                           return
                       }
               
                   do {
                     
                      
                       let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                       print(json)
                       
                       if let items = json["paymentFee"] as? [[String: AnyObject]] {
                       //for each result make a book and add title
                           for item in items {
                                   
                                 let paymentMethod = item["paymentMethod"] as? String
                                 let paymentName = item["paymentName"] as? String
                                 let paymentImage = item["paymentImage"] as? String
                                 let totalFee = item["totalFee"] as? String

                               self.listPayment_.append(listPayment(paymentMethod!,paymentName!,paymentImage!,totalFee!))
                               
                            
                                 self.tablePayment.reloadData()
                              helper.setLoadingDuitku(Image: self.LoadingDuitku, view: self.CardLoading , hidden: true)
                               
                               
                               }
                       }
                       
                   } /*catch {
                        helper.setLoadingDuitku(Image: self.LoadingDuitku, view: self.CardLoading , hidden: true)
                       helper.setErrorDuitku(Image: self.ImageError, view: self.CardError , hidden: false , textError: self.textError , message: error.localizedDescription)
                           
                                          print(error)
                   }
                   */
                   
                   
                   
               }
          }.resume()
   }
    
    
    
    
    
    
}

 



extension ListPaymentDuitku: UITableViewDelegate, UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPayment_.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let list = listPayment_[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellPayment") as! TableViewCellPayment
        
        // insert to cell of list
        cell.setListPayment(list)
        
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                    
        
       
            //navigation to second controller
            let vc = storyboard?.instantiateViewController(withIdentifier:"CheckoutDuitkuStoryboard") as!CheckoutDuitku
           //  let vc = storyboard?.instantiateViewController(withIdentifier:"ciobaStoryboard") as!Coba
            // passing data to second controller
            let dataPayment = listPayment_[indexPath.row]
            vc.paymentMethod = dataPayment.paymentMethod
        
            
    
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController!.setNavigationBarHidden(true, animated: true)
            self.navigationController!.pushViewController(vc, animated: true)
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
           //   let storyboard = UIStoryboard.init(name: "ListPaymentDuitku", bundle: Bundle(for: ListPaymentDuitku.self))
           // let vc = storyboard.instantiateViewController(withIdentifier: "listPaymentDuitku")
        
        
         
        
           // self.present(vc,animated: true)



         
       
    }
    
    
    //set style of table
    func setStyleTablePayment() {
              self.tablePayment.dataSource = self
              self.tablePayment.delegate = self
              self.tablePayment.layer.shadowColor = UIColor.gray.cgColor
              self.tablePayment.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
              self.tablePayment.layer.shadowOpacity = 0.7
    }
    
 
    
    
    
}





 extension String{
    func convertDoubleToCurrency() -> String{
        let amount1 = Double(self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")
        return numberFormatter.string(from: NSNumber(value: amount1!))!
    }
}




