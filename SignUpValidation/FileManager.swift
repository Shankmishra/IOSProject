//
//  FileManager.swift
//  SignUpValidation
//
//  Created by cl-macmini-110 on 21/02/19.
//  Copyright © 2019 cl-macmini-110. All rights reserved.
//

import Foundation
import UIKit
class FileManagers {
    
    func getDocumentsDirectory() -> URL {
        var paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func getImage(imageName : String) -> UIImage {
        let fileManager = FileManager.default
        // Here using getDirectoryPath method to get the Directory path
        let filename = "profile.png"
        let imagePath = getDocumentsDirectory().appendingPathComponent(filename).path
        if fileManager.fileExists(atPath: imagePath){
            return UIImage(contentsOfFile: imagePath)!
        }else{
            print("No Image available")
            return UIImage(named: "icDone.png")! // Return placeholder image here
        }
    }
}
