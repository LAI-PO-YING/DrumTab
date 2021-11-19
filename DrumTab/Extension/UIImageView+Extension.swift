//
//  UIImageView+Extension.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/11/19.
//

import Foundation
import UIKit

extension UIImageView {
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {

            self.image = nil
            //If imageurl's imagename has space then this line going to work for this
            let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            

            if let url = URL(string: imageServerUrl) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                    //print("RESPONSE FROM API: \(response)")
                    if error != nil {
                        print("ERROR LOADING IMAGES FROM URL: \(error)")
                        DispatchQueue.main.async {
                            self.image = placeHolder
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        if let data = data {
                            if let downloadedImage = UIImage(data: data) {
                           
                                self.image = downloadedImage
                            }
                        }
                    }
                }).resume()
            }
        }
}
