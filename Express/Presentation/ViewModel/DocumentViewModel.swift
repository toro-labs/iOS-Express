//
//  IDDocumentViewModel.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 7/1/21.
//

import Combine
import CoreData
import SwiftUI

class IDDocumentViewModel: ObservableObject {
    // MARK: - Observable Attributes
    
    @Published var idImage: UIImage
    @Published var idBackImage: UIImage
    @Published var carLicenseImage: UIImage
    @Published var carLicenseBackImage: UIImage
    
    // MARK: Life Cycle
    
    init() {
        self.carLicenseBackImage = UIImage(named: "licencia-trasera")!
        self.carLicenseImage = UIImage(named: "licencia")!
        self.idBackImage = UIImage(named: "cedula-trasera")!
        self.idImage = UIImage(named: "cedula")!
    }
    
    // MARK: Setup
    
    func createIDDocument(context: NSManagedObjectContext) -> IDDocument {
        let idDoc = IDDocument(context: context)
        
        idDoc.idCard = idImage.pngData()
        idDoc.idBackCard = idBackImage.pngData()
        idDoc.licenseCard = carLicenseImage.pngData()
        idDoc.licenseBackCard = carLicenseBackImage.pngData()
        
        return idDoc
    }
}
