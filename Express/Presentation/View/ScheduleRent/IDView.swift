//
//  IDView.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 7/1/21.
//

import SwiftUI

struct DocumentView: View {
    // MARK: - Inner Types
    enum DocumentType {
        case idCard
        case licenseCard
    }
    
    // MARK: Observable Properties
    
    @ObservedObject private var viewModel: IDDocumentViewModel
    @State private var flipped = false
    @State private var showIDActionSheet = false
    @State private var showIDBackActionSheet = false
    
    // MARK: Properties
    
    private let documentType: DocumentType
    
    
    // MARK: SwiftUI Container
    
    var body: some View {
        Section(header: getTitle(documentType: documentType)) {
            
            let flipDegrees = flipped ? 180.0 : 0
            let image = getImage(documentType: documentType)
            let backImage = getBackImage(documentType: documentType)
            
            VStack {
                Spacer()

                ZStack {
                    Image(uiImage: image.wrappedValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 200)
                        .flipRotate(flipDegrees)
                        .opacity(flipped ? 0.0 : 1.0)
                        .onTapGesture {
                            showIDActionSheet.toggle()
                        }
                        .sheet(isPresented: $showIDActionSheet, content: {
                            ImagePicker(sourceType: .photoLibrary, image: image, isPresented: $showIDActionSheet)
                        })
                    
                    Image(uiImage: backImage.wrappedValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 200)
                        .flipRotate(-180 + flipDegrees)
                        .opacity(flipped ? 1.0 : 0.0)
                        .onTapGesture {
                            showIDBackActionSheet.toggle()
                        }
                        .sheet(isPresented: $showIDBackActionSheet, content: {
                            ImagePicker(sourceType: .photoLibrary, image: backImage, isPresented: $showIDBackActionSheet)
                        })
                }
                .animation(.easeInOut(duration: 0.8))
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded() { value in
                            if value.translation.width < 0 {
                                flipped.toggle()
                            }

                            if value.translation.width > 0 {
                                flipped.toggle()
                            }
                        }
                )
                
                Spacer()
            }
        }
    }
    
    // MARK: Initializer
    
    init(viewModel: IDDocumentViewModel, type: DocumentType) {
        self.viewModel = viewModel
        self.documentType = type
    }
    
    // MARK: Setup
    
    func getBackImage(documentType: DocumentType) -> Binding<UIImage> {
        return documentType == .idCard ? $viewModel.idBackImage : $viewModel.carLicenseBackImage
    }
    
    func getImage(documentType: DocumentType) -> Binding<UIImage> {
        return documentType == .idCard ? $viewModel.idImage : $viewModel.carLicenseImage
    }
    
    func getTitle(documentType: DocumentType) -> Text {
        return documentType == .idCard ? Text("Cédula") : Text("Licencia")
    }
}

struct IDView: View {
    // MARK: - Observable Properties
    
    @ObservedObject var viewModel: IDDocumentViewModel
    @State var flipped = false
    @State var flipped2 = false
    @State var showIDActionSheet = false
    @State var showIDBackActionSheet = false
    @State var showCLActionSheet = false
    @State var showCLBackActionSheet = false
    
    // MARK: SwiftUI Container
    
    var body: some View {
        Form {
            
            DocumentView(viewModel: viewModel, type: .idCard)
            
            DocumentView(viewModel: viewModel, type: .licenseCard)
            
        }
        .navigationBarTitle("Identificaciones")
        
    }
}

struct IDView_Previews: PreviewProvider {
    static var previews: some View {
        IDView(viewModel: IDDocumentViewModel())
    }
}
