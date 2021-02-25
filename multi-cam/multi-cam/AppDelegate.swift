//
//  AppDelegate.swift
//  multi-cam
//
//  Created by Justin Dulay on 12/9/20.
//

import ARKit
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let supportForSceneReconstruction = ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        guard supportForSceneReconstruction else {
            fatalError("Scene Reconstruction isn't supported here")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func postData() {
        let url = URL(string: "http://192.168.1.109:5000/") // trying with IP address
        let session = URLSession.shared

        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        
        let boundary = UUID().uuidString

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let retreivedImage: UIImage? = imageCache[0]
        print(url)
        print("the fucking imageCache", imageCache)
        
        
        
        
        //Get image
//            do {
//                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//                let readData = try Data(contentsOf: URL(string: "file://\(documentsPath)/myImage")!)
//                retreivedImage = UIImage(data: readData)
//    //            addProfilePicView.setImage(retreivedImage, for: .normal)
//            }
//            catch {
//                print("Error while opening image")
//                return
//            }

        let imageData = retreivedImage!.jpegData(compressionQuality: 1)
        if (imageData == nil) {
            print("UIImageJPEGRepresentation return nil")
            return
        }

        var body = Data()
        var paramName = "paramName"
        var fileName = "img.jpeg"
        // Add the image data to the raw http request data
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        body.append(imageData!)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
//            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
//            body.append(NSString(format: "Content-Disposition: form-data; name=\"api_token\"\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
////            body.append(NSString(format: (UserDefaults.standard.string(forKey: "api_token")! as NSString)).data(using: String.Encoding.utf8.rawValue)!) // try without adding this api key thing to it
//            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
//            body.append(NSString(format:"Content-Disposition: form-data; name=\"profile_img\"; filename=\"testfromios.jpg\"\r\n").data(using: String.Encoding.utf8.rawValue)!)
//            body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
//            body.append(imageData!)
//            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)

        request.httpBody = body
        dump(request)
        dump(body)
        
        
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: request, from: body, completionHandler: { responseData, response, error in
            print("error is ", error)
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            }
        }).resume()
    }
}
