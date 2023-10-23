//
//  ViewController.swift
//  APICall-Demo
//
//  Created by Shakir Husain on 29/09/23.
//

import UIKit

class ViewController: UIViewController,APIDelegate {
        
    var productList:[SDMProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let service = APIService()
        service.delegate = self
        service.fetchProducts(urlStr: "https://fakestoreapi.com/products")
        
            
    }
    // delegate method or call back method
    func didGetProducts(success: Bool, products: Any?) {
        
        if let list = products as? [Any]{
            
            for item in list{
                               
                var product = SDMProduct()
                
                if let aDict = item as? [String:Any]{
                    
                    if let value = aDict["id"] as? Int{
                        product.id = value
                    }
                    if let value = aDict["title"] as? String{
                        product.title = value

                    }
                    if let value = aDict["category"] as? String{
                        product.category = value

                    }
                    if let value = aDict["description"] as? String{
                        product.description = value

                    }
                    if let value = aDict["image"] as? String{
                        product.image = value

                    }
                }
                productList.append(product)
            }
        }
        
    }
}



//Step 1 :- Create protocols
//Step 2 :- Create APIService Class to handle API Call from server
//Step 3 :- Confirm and implement APIDelegate in UI Class

protocol APIDelegate {
    func didGetProducts(success:Bool,products:Any?)
}

class APIService{
    
    var delegate:APIDelegate?
    
    func fetchProducts(urlStr:String) {
        
        if let url = URL(string: urlStr){
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let aResponse = response as? HTTPURLResponse,aResponse.statusCode == 200,data != nil && error == nil{

                    if let jsonObject = try? JSONSerialization.jsonObject(with: data!){
                        self.delegate?.didGetProducts(success: true, products: jsonObject)
                    }
                }else{
                    self.delegate?.didGetProducts(success: false, products: nil)
                }
            }
            task.resume()
        }else
        {
            print("url not supported!")
            self.delegate?.didGetProducts(success: false, products: nil)
        }
    }
}

struct SDMProduct {
   
    var id:Int?
    var title:String?
    var category:String?
    var description:String?
    var image:String?
}
