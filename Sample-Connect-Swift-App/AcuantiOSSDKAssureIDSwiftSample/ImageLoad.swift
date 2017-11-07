//
//  ImageLoad.swift
//  AcuantiOSSDKAssureIDSwiftSample
//
//  Created by Tapas Behera on 8/7/17.
//  Copyright © 2017 Acuant. All rights reserved.
//

import Foundation
extension UIImageView {
    func downloadedFrom(urlStr:String,username:String,password:String) {
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        // create the request
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                self.isHidden=false;
            }
            }.resume()
    }
    
}
