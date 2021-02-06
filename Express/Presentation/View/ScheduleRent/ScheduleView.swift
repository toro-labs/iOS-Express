//
//  ScheduleView.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 30/12/20.
//

import SwiftUI

struct ScheduleView: View {
    // MARK: - Observable Properties
    
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var docViewModel = IDDocumentViewModel()
    @ObservedObject var viewModel = RentScheduleViewModel()
    
    // MARK: SwiftUI Container
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Cliente")) {
                    TextField("Nombre y Apellido", text: $viewModel.name)
                    TextField("Celular", text: $viewModel.cellphone)
                    TextField("Lugar de Residencia", text: $viewModel.place)
                    NavigationLink("Documentos de Identidad", destination: IDView(viewModel: docViewModel))
                }
                
                Section(header: Text("Alquiler")) {
                    Picker(selection: $viewModel.selectedCar, label: Text("Carro"), content: {
                        Text("Honda CRV 2000").tag(CarModel.honda2000)
                        Text("Honda CRV 2004").tag(CarModel.honda2004)
                        Text("Honda CRV 2010").tag(CarModel.honda2010)
                        Text("Nissan Xtrail").tag(CarModel.nissan)
                    })
                    DatePicker("Desde", selection: $viewModel.from)
                    DatePicker("Hasta", selection: $viewModel.to)
                }
                
                Section(header: Text("Opciones")) {
                    Toggle(isOn: $viewModel.booked, label: {
                        Image(systemName: "bookmark.circle")
                        Text("Reservación")
                    })
                    
                    Toggle(isOn: $viewModel.paymentInDollar, label: {
                        Image(systemName: "dollarsign.circle")
                        Text("Cobro en Dolares")
                    })
                }
                
                Section(header: Text("Pago")) {
                    HStack {
                        Text("Monto a pagar")
                        
                        Spacer()
                        
                        Text(viewModel.currency)
                        
                        TextField("", text: $viewModel.money)
                            .frame(width: viewModel.textFieldFrame, alignment: .trailing)
                    }
                    
                    if viewModel.booked {
                        HStack {
                            Text("Deposito")
                            
                            Spacer()
                            
                            Text(viewModel.currency)
                            
                            TextField("", text: $viewModel.money)
                                .frame(width: viewModel.textFieldFrame, alignment: .trailing)
                        }
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button(viewModel.buttonTitle, action: {
                            viewModel.rent(context: moc, idDocument: docViewModel.createIDDocument(context: moc))
                        })
                            .frame(alignment: .center)
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Alquiler")
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
