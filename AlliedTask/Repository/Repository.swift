//
//  Repository.swift
//  AlliedTask
//
//  Created by Adel Aref on 12/11/2021.
//

import Foundation
import UIKit
import Alamofire
// swiftlint:disable all
protocol Repository {
    var networkClient: APIRouter { get }
    var cacher: Cacher { get }
    func getData<T: Cachable>(withRequest: URLRequest,
                              name: String?,
                              decodingType: T.Type,
                              strategy: Strategy,
                              completion: @escaping RepositoryCompletion)
    where T: Codable
}

extension Repository {
    typealias RepositoryCompletion = (RequestResult<Cachable, RequestError>) -> Void
    func getData<T: Cachable>(withRequest: URLRequest,
                              name: String?,
                              decodingType: T.Type,
                              strategy: Strategy = .networkOnly,
                              completion: @escaping RepositoryCompletion)
    where T: Codable {

        switch strategy {
        case .networkOnly:
            print("network")
        case .offlineOnly:
            if let name = name {
                let cached: T? = self.cacher.load(fileName: name)
                completion(.success(cached))
                return
            }
            break
        case .offlineFirstFile:
            if let name = name {
                let cached: T? = self.cacher.load(fileName: name)
                completion(.success(cached))
            }
        default:
            print("default")
        }
        networkClient.makeRequest(withRequest: withRequest, decodingType: decodingType) { (result) in
            switch result {
            case .success(let data):
                if let name = name {
                    self.cacher.persist(item: data!, name: name) { (url, error) in
                    }
                }
            case .failure(.timeOut):
                showAlertConnectionError(withMessege: "The request timed out.")
            case .failure(.connectionError):
                //showAlertConnectionError(withMessege: "No Internet connection.")
                if let name = name {
                    let cached: T? = self.cacher.load(fileName: name)
                    completion(.success(cached))
                }
            case .failure(.jsonConversionFailure):
                print("jsonConversionFailure")
            default :
                if let name = name {
                    let cached: T? = self.cacher.load(fileName: name)
                    completion(.success(cached))
                }
                return
            }
            completion(result)
        }
    }
    // swiftlint:disable:next function_parameter_count
    func uploadData<T: Cachable>(withUrl: URLRequest,
                                 data: Data?,
                                 andName: String,
                                 name: String,
                                 image: UIImage?,
                                 decodingType: T.Type,
                                 completion: @escaping RepositoryCompletion)
    where T: Codable {
        networkClient.uploadRequest(image: data!, to: withUrl, params: nil, decodingType: decodingType) { (result) in
            switch result {
            case .success(let data):
                self.cacher.persist(item: data!) { (_, _) in
                }
            default :
                let cached: T? = self.cacher.load(fileName: name)
                completion(.success(cached))
                return
            }
            completion(result)
        }
    }
    func uploadImages<T: Cachable>(withUrl: URLRequest,
                                   data: [Data]?,
                                   andName: String,
                                   name: String,
                                   image: [UIImage]?,
                                   decodingType: T.Type,
                                   completion: @escaping RepositoryCompletion)
    where T: Codable {
        networkClient.uploadImages(images: data!, to: withUrl, params: nil, decodingType: decodingType) { (result) in
            switch result {
            case .success(let data):
                self.cacher.persist(item: data!) { (_, _) in
                }
            default :
                let cached: T? = self.cacher.load(fileName: name)
                completion(.success(cached))
                return
            }
            completion(result)
        }
    }

}
func showAlertConnectionError(withMessege: String) {
    let alertController =
        UIAlertController(title: nil, message: withMessege, preferredStyle: UIAlertController.Style.alert)
    let okAction =
        UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil)
    alertController.addAction(okAction)
//    UIApplication.getTopViewController()?.present(alertController, animated: true, completion: nil)
}
