//
//  FormData.swift
//  HealthTracker-ios
//
//  Created by sergey on 20.11.2024.
//

import Foundation

struct FormData {
    let key: String
    let value: Data
    let mimeType: String?
    let filename: String?
    
    init(key: String, value: String) {
        self.key = key
        self.value = Data(value.utf8)
        self.mimeType = nil
        self.filename = nil
    }
    
    init(key: String, fileData: Data, mimeType: String, filename: String? = nil) {
        self.key = key
        self.value = fileData
        self.mimeType = mimeType
        self.filename = filename
    }
}

struct MultipartFormData {
    private let boundary: String
    private var fields: [FormData] = []
    
    init(boundary: String = "Boundary-\(UUID().uuidString)") {
        self.boundary = boundary
    }
    
    init(fields: [FormData]) {
        self.init()
        self.fields = fields
    }
    
    mutating func addField(key: String, value: String) {
        fields.append(FormData(key: key, value: value))
    }
    
    mutating func addFile(key: String, fileData: Data, mimeType: String, filename: String) {
        fields.append(FormData(key: key, fileData: fileData, mimeType: mimeType, filename: filename))
    }
    
    func build() -> (body: Data, contentType: String) {
        var body = Data()
        
        for field in fields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            
            if let mimeType = field.mimeType {
                if let filename = field.filename {
                    body.append("Content-Disposition: form-data; name=\"\(field.key)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                } else {
                    body.append("Content-Disposition: form-data; name=\"\(field.key)\"\r\n".data(using: .utf8)!)
                }
                
                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            } else {
                body.append("Content-Disposition: form-data; name=\"\(field.key)\"\r\n\r\n".data(using: .utf8)!)
            }
            
            body.append(field.value)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return (body, "multipart/form-data; boundary=\(boundary)")
    }
}
