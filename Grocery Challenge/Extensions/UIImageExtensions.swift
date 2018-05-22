//
//  UIImageExtensions.swift
//  Grocery Challenge
//
//  Created by Andrew Crookston on 5/14/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit

enum UIImageError: Error {
    case invalidData
}

extension UIImage {
    /// Loads an UIImage from internet asynchronously
    static func asyncFrom(url: URL, api: API = ChallengeAPI(), _ completion: @escaping (Result<UIImage>) -> Void) {
        api.image(from: url) { result in
            switch result {
            case .success(let data):
                asyncFrom(data: data, completion)
            case .error(let error):
                completion(.error(error))
            }
        }
    }

    private static func asyncFrom(data: Data, _ completion: @escaping (Result<UIImage>) -> Void) {
        DispatchQueue.global(qos: .default).async {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.error(UIImageError.invalidData))
                }
            }
        }
    }
}
