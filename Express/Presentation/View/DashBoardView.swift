//
//  DashBoardView.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 30/12/20.
//

import SwiftUI

struct DashBoardView: View {
    // MARK: - Observable Properties
    
    @Environment(\.availableCars) var cars
    @ObservedObject private var viewModel = DashboardViewModel()
    @State var showAlert = false
    
    // MARK: SwiftUI Container
    
    var body: some View {
        NavigationView {
            Form {
                let (fromDate, toDate) = viewModel.getOcupationDate()
                
                Section {
                    Picker(selection: $viewModel.selectedCar, label: Text("Carro"), content: {
                        Text("Honda CRV 2000").tag(CarModel.honda2000)
                        Text("Honda CRV 2004").tag(CarModel.honda2004)
                        Text("Honda CRV 2010").tag(CarModel.honda2010)
                        Text("Nissan Xtrail").tag(CarModel.nissan)
                    })
                }
                
                Section(header: Text("Hoy")) {
                    HStack {
                        DateView(viewModel.actualDate)
                            .padding(.trailing, 10)
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            if let client = viewModel.client {
                                Text(client.completeName ?? "")
                                Text("Celular: \(client.cellphone ?? "")")
                            } else {
                                Text("No hay cliente")
                            }
                        }
                        .onTapGesture {
                            if viewModel.client != nil {
                                viewModel.showPhoneAlert.toggle()
                            }
                        }
                        .alert(isPresented: $viewModel.showPhoneAlert) {
                            Alert(title: Text("Llamada"), message: Text("Esta seguro que quiere llamar a \(viewModel.client!.completeName!)"), primaryButton: .default(Text("Si"), action: { Phone.call(viewModel.client!.cellphone!) }), secondaryButton: .cancel(Text("No")))
                        }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.width < 0 {
                                viewModel.nextDay()
                                viewModel.getClient()
                            }

                            if value.translation.width > 0 {
                                viewModel.previousDay()
                                viewModel.getClient()
                            }
                        }
                )
                
                Section(header: Text("Ocupación")) {
                    HStack {
                        Spacer()
                        
                        if viewModel.client == nil {
                            Text("Disponible")
                                .bold()
                                .foregroundColor(.green)
                        } else {
                            HStack(alignment: .center) {
                                DateView(fromDate)
                                    .frame(minWidth: 0, maxWidth: 100, alignment: .center)

                                Divider()

                                DateView(toDate)
                                    .frame(minWidth: 0, maxWidth: 100, alignment: .center)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                if viewModel.client != nil {
                    Section(header: Text("Entrega de Vehículo")) {
                        HStack {
                            Spacer()
                            
                            DateTimeView(toDate)
                            
                            Spacer()
                        }
                    }
                }
                
                if viewModel.isRented() {
                    Section(header: Text("Alquiler en Curso")){
                        HStack{
                            Spacer()
                            
                            Button(action: {
                                self.showAlert = true
                            }) {
                                Text("Acabar Alquiler")
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Finalizar Alquiler"), message: Text("Desea finalizar el alquiler?"), primaryButton: .default(Text("Si"), action: {
                                    viewModel.finishRent()
                                }), secondaryButton: .default(Text("No")))
                            }
                            .foregroundColor(.red)
                            
                            Spacer()
                        }
                    }
                }
                
            }
            .navigationTitle("Express Rent a Car")
        }
    }
}

struct DashBoard_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardView()
    }
}
