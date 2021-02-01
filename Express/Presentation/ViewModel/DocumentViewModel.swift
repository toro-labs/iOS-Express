//
//  IDDocumentViewModel.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 7/1/21.
//

import Combine
import CoreData
import SwiftUI

enum DocumentType {
    case idCard
    case licenseCard
}

class DocumentViewModel: ObservableObject {
    // MARK: - Attributes
    
    private var cancellables: Set<AnyCancellable> = []
    
    var title: String {
        return documentType == .idCard ? "Cédula" : "Licencia"
    }
    
    var documentType: DocumentType!
    
    // MARK: Observable Attributes
    
    @Published var carLicenseImage: UIImage
    @Published var carLicenseBackImage: UIImage
    @Published var flipped: Bool
    @Published var idImage: UIImage
    @Published var idBackImage: UIImage
    @Published var showIDActionSheet: Bool
    @Published var showIDBackActionSheet: Bool
    
    @Published var flipDegrees: Double = 0 // viewModel.flipped ? 180.0 : 0
    @Published var opacity = 1.0 // viewModel.flipped ? 0.0 : 1.0
    @Published var backOpacity = 0.0 // viewModel.flipped ? 1.0 : 0.0
    
    // MARK: Life Cycle
    
    init() {
        self.carLicenseBackImage = UIImage(named: "licencia-trasera")!
        self.carLicenseImage = UIImage(named: "licencia")!
        self.flipped = false
        self.idBackImage = UIImage(named: "cedula-trasera")!
        self.idImage = UIImage(named: "cedula")!
        self.showIDActionSheet = false
        self.showIDBackActionSheet = false
        
        initObsevables()
    }
    
    func initObsevables() {
        $flipped
            .receive(on: RunLoop.main)
            .map { $0 ? 180.0 : 0 }
            .assign(to: \.flipDegrees, on: self)
            .store(in: &cancellables)
        
        $flipped
            .receive(on: RunLoop.main)
            .map { $0 ? 0.0 : 1.0 }
            .assign(to: \.opacity, on: self)
            .store(in: &cancellables)
        
        $flipped
            .receive(on: RunLoop.main)
            .map { $0 ? 1.0 : 0.0 }
            .assign(to: \.backOpacity, on: self)
            .store(in: &cancellables)
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
    
    func getTitle() -> Text {
        return documentType == .idCard ? Text("Cédula") : Text("Licencia")
    }
}
