//
//  DashBoardView.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 30/12/20.
//

import SwiftUI

struct DateView: View {
    // MARK: - Properties
    
    let date: [String]
    
    private var weekName: String {
        return date[0]
    }
    
    private var day: String {
        return date[1]
    }
    
    private var month: String {
        return date[2]
    }
    
    // MARK: SwiftUI Container
    
    var body: some View {
        VStack {
            Text(weekName)
                .font(.callout)
                .foregroundColor(.red)
            Text(day)
                .font(.title)
                .bold()
            Text(month)
                .font(.caption)
        }
    }
}

struct DashBoardView: View {
    // MARK: - Properties
    
    private var dateComponentes: [String] {
        return DateUtil.shared.getDateComponents(actualDate)
    }
    
    // MARK: Observable Properties
    
    @Environment(\.availableCars) var cars
    @ObservedObject private var viewModel = DashboardViewModel()
    @State private var selectedCar = CarModel.honda2010
    @State private var actualDate = Date()
    
    // MARK: SwiftUI Container
    
    var body: some View {
        NavigationView {
            Form {
                let client = viewModel.getClient(from: .init(model: selectedCar.rawValue, fromDate: DateUtil.shared.getStartDay(actualDate), toDate: DateUtil.shared.getEndDay(actualDate)))
                
                Section {
                    Picker(selection: $selectedCar, label: Text("Carro"), content: {
                        Text("Honda CRV 2000").tag(CarModel.honda2000)
                        Text("Honda CRV 2004").tag(CarModel.honda2004)
                        Text("Honda CRV 2010").tag(CarModel.honda2010)
                        Text("Nissan Xtrail").tag(CarModel.nissan)
                    })
                }
                
                Section(header: Text("Hoy")) {
                    HStack {
                        
                        DateView(date: dateComponentes)
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            if let client = client {
                                Text(client.completeName ?? "")
                                Text("Celular: \(client.cellphone ?? "")")
                            } else {
                                Text("No hay cliente")
                            }
                        }
                        .onTapGesture {
                            if client != nil {
                                viewModel.showPhoneAlert.toggle()
                            }
                        }
                        .alert(isPresented: $viewModel.showPhoneAlert, content: {
                            return Alert(title: Text("Llamada"), message: Text("Esta seguro que quiere llamar a \(client!.completeName!)"), primaryButton: .default(Text("Si"), action: { Phone.call(client!.cellphone!) }), secondaryButton: .cancel(Text("No")))
                        })
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.width < 0 {
                                self.actualDate = self.actualDate.addingTimeInterval(24*60*60)
                            }

                            if value.translation.width > 0 {
                                self.actualDate = self.actualDate.addingTimeInterval(-24*60*60)
                            }
                        }
                )
                
                Section(header: Text("Ocupación")) {
                    HStack {
                        Spacer()
                        
                        if client == nil {
                            Text("Disponible")
                                .bold()
                                .foregroundColor(.green)
                        } else {
                            HStack {
                                DateView(date: dateComponentes)
                                
                                Spacer()
                                    .frame(width: 100)
                                
                                DateView(date: dateComponentes)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                if client != nil {
                    Section(header: Text("Entrega de Vehículo")) {
                        HStack {
                            Spacer()
                            
                            HStack(spacing: 25) {
                                DateView(date: dateComponentes)
                                
                                DateView(date: dateComponentes)
                            }
                            
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
