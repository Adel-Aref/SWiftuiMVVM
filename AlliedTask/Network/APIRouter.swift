//
//  APIRouter.swift
//  EvaPharmaTask
//
//  Created by Adel Aref on 12/11/2021.
//

import Foundation

import Alamofire
// swiftlint:disable all
protocol APIRouter {
    func makeRequest(withRequest: URLRequest, completion: @escaping JSONTaskCompletionHandler)
    func makeRequest<T: Cachable>(withRequest: URLRequest,
                                  decodingType: T.Type,
                                  completion: @escaping JSONTaskCompletionHandler)  where T: Codable
    func uploadRequest<T: Cachable>(image: Data,
                                    to url: Alamofire.URLRequestConvertible, params: [String: Any]?,
                                    decodingType: T.Type,
                                    completion: @escaping JSONTaskCompletionHandler) where T: Codable
    func uploadImages<T: Cachable>(images: [Data],
                                    to url: URLRequest, params: [String: String]?,
                                    decodingType: T.Type,
                                    completion: @escaping JSONTaskCompletionHandler) where T: Codable
}

extension APIRouter {
    typealias JSONTaskCompletionHandler = (RequestResult<Cachable, RequestError>) -> Void
    func uploadRequest<T: Cachable>(image: Data,
                                    to url: Alamofire.URLRequestConvertible, params: [String: Any]?,
                                    decodingType: T.Type,
                                    completion: @escaping JSONTaskCompletionHandler) where T: Codable {
        AF.upload(multipartFormData: { multiPart in
            if let params = params {
                for (key, value) in params {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
            }
            multiPart.append(image, withName: "file", fileName: "file.png", mimeType: "image/png")
        }, with: url)
        .uploadProgress(queue: .main, closure: { progress in
        })
        .responseJSON(completionHandler: { data in
            //Do what ever you want to do with response
            switch data.result {
            case .success(let result):
                guard let resultt = result as? Data else {
                    completion(.failure(.invalidResponse))
                    return
                }
                self.decodeJsonResponse(decodingType: decodingType,
                                        jsonObject: resultt,
                                        completion: completion)
            case .failure:
                completion(.failure(.invalidResponse))
            }
        })
    }
    func makeRequest(withRequest: URLRequest, completion: @escaping JSONTaskCompletionHandler) {
        AF.request(withRequest)
            .responseJSON(completionHandler: { (response) in
                if let error = response.error {
                    print(error)
                    completion(.failure(.connectionError))
                } else {
                    print(response)
                    if let code = response.response?.statusCode {
                        let result = response.result
                        switch code {
                        case 200:
                            //completion(.success(responseJson))
                            switch result {
                            case .success(let _):
                                completion(.success(nil))
                            default:
                                completion(.failure(.unknownError))
                            }
                        case 400 ... 499:
                            completion(.failure(.authorizationError))
                        case 500 ... 599:
                            completion(.failure(.serverError))
                        default:
                            completion(.failure(.unknownError))
                        }
                    }
                }
            })
    }
    func makeRequest<T: Cachable>(withRequest: URLRequest,
                                  decodingType: T.Type,
                                  completion: @escaping JSONTaskCompletionHandler)  where T: Codable {
        AF.request(withRequest)
            .responseJSON(completionHandler: { (response) in
                if let error = response.error {
                    if error.localizedDescription == "The request timed out." {
                        completion(.failure(.timeOut))
                    } else {
                        completion(.failure(.connectionError))
                    }
                } else if let data = response.data {
                    print(response)
                    if let code = response.response?.statusCode {
                        switch code {
                        case 200:
                            self.decodeJsonResponse(
                                decodingType: decodingType,
                                jsonObject: data,
                                completion: completion)
                        case 400 ... 499:
                            completion(.failure(.authorizationError))
                        case 500 ... 599:
                            completion(.failure(.serverError))
                        default:
                            completion(.failure(.unknownError))
                        }
                    }
                }
            })
    }

    func uploadImages<T: Cachable>(images: [Data],
                                    to url: URLRequest, params: [String: String]?,
                                    decodingType: T.Type,
                                    completion: @escaping JSONTaskCompletionHandler) where T: Codable {
        AF.upload(multipartFormData: { multiPart in
            images.indices.forEach {
                multiPart.append(images[$0], withName: "file[\($0)]", fileName: "swift_file\($0).jpeg", mimeType: "image/jpeg")
            }
            if let param = params {
                for (key, value) in param {
                    multiPart.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, with: url)
        .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { (response) in
            //Do what ever you want to do with response
            if let error = response.error {
                if error.localizedDescription == "The request timed out." {
                    completion(.failure(.timeOut))
                } else {
                    completion(.failure(.connectionError))
                }
            } else if let data = response.data {
                if let code = response.response?.statusCode {
                    switch code {
                    case 200:
                        self.decodeJsonResponse(
                            decodingType: decodingType,
                            jsonObject: data,
                            completion: completion)
                    case 400 ... 499:
                        completion(.failure(.authorizationError))
                    case 500 ... 599:
                        completion(.failure(.serverError))
                    default:
                        completion(.failure(.unknownError))
                    }
                }
            }
        })
    }
    func decodeJsonResponse<T: Cachable>(decodingType: T.Type,
                                         jsonObject: Data,
                                         completion: @escaping JSONTaskCompletionHandler) where T: Codable {
        do {
            var genericModel = try JSONDecoder().decode(decodingType, from: jsonObject)
            genericModel.fileName = String(describing: T.self)
            completion(.success(genericModel))
        } catch {
            completion(.failure(.jsonConversionFailure))
        }
    }
}
func makeRequest(url: URL, headers: Any?, parameters: Any?, query: [URLQueryItem]?, type: HTTPMethod) -> URLRequest? {
    print(url.absoluteURL)


    var urll = URLComponents(url: url, resolvingAgainstBaseURL: true)
    if let query = query {
        urll?.queryItems = query
    }
    guard let finalURL = urll?.url else { return nil }
    var urlRequest = URLRequest(url: finalURL, timeoutInterval: 10)
    do {
        urlRequest.httpMethod = type.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let parameters = parameters {
            urlRequest.httpBody   = try JSONSerialization.data(withJSONObject: parameters)
        }
        if let headers = headers as? [String: String] {
            urlRequest.allHTTPHeaderFields = headers
        }
        return urlRequest
    } catch let error {
        print("Error : \(error.localizedDescription)")
    }
    return urlRequest
}
