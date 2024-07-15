//
//  FaceDetectionService.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-15.
//

import Foundation

import UIKit
import Vision

struct FaceDetectionResult {
    let faceDetected: Bool
    let faceBounds: CGRect?
}

class FaceDetectionService {
    enum FaceDetectionError: Error {
        case noFacesDetected
        case requestFailed(Error)
        case invalidImage
        case cancelled
    }
    
    private var currentRequest: VNRequest?
    
    func detectFace(image: UIImage, completion: @escaping (Result<FaceDetectionResult, FaceDetectionError>) -> Void) -> CancellationToken {
        let cancellationToken = CancellationToken()
        
        guard let ciImage = CIImage(image: image) else {
            completion(.failure(.invalidImage))
            return cancellationToken
        }

        let faceDetectionRequest = VNDetectFaceRectanglesRequest { [unowned self] request, error in
            if cancellationToken.isCancelled {
                self.currentRequest = nil
                completion(.failure(.cancelled))
                return
            }

            guard let results = request.results as? [VNFaceObservation], !results.isEmpty else {
                completion(.failure(.noFacesDetected))
                return
            }
            
            // [AL] not sure why but for images that do not contain faces it always returns error
            // [AL] Checking error after checking if results were empty and assuming no faces were detected
            if error != nil {
                completion(.failure(.noFacesDetected))
                return
            }
            
            // [AL] Assuming we only have one possible face in profile photo for simplicity
            if let face = results.first {
                let boundingBox = face.boundingBox
                let faceBounds = CGRect(x: boundingBox.origin.x * image.size.width,
                                        y: (1 - boundingBox.origin.y - boundingBox.height) * image.size.height,
                                        width: boundingBox.width * image.size.width,
                                        height: boundingBox.height * image.size.height)
                
                let faceDetectionResult = FaceDetectionResult(faceDetected: true, faceBounds: faceBounds)
                completion(.success(faceDetectionResult))
            } else {
                completion(.failure(.noFacesDetected))
            }
            
            self.currentRequest = nil
        }
        
#if targetEnvironment(simulator)
        faceDetectionRequest.usesCPUOnly = true
#endif
        
        self.currentRequest = faceDetectionRequest
        
        let requestHandler = VNImageRequestHandler(ciImage: ciImage)
        
        DispatchQueue.global().async {
            do {
                try requestHandler.perform([faceDetectionRequest])
            } catch {
                if !cancellationToken.isCancelled {
                    completion(.failure(.requestFailed(error)))
                }
            }
        }
        
        return cancellationToken
    }
    
    func cancel() {
        currentRequest?.cancel()
        currentRequest = nil
    }
}

class CancellationToken {
    var isCancelled: Bool = false
    
    func cancel() {
        isCancelled = true
    }
}
