//
//  RentHistoryView.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 2/1/21.
//

import SwiftUI

struct Client: Hashable {
    let name: String
    let from: String
    let to: String
    let daysNumber: Int
    let amount: Int
}

struct RentHistoryView: View {
    // MARK: - Observable Properties
    
    @Environment(\.availableCars) var cars
    @FetchRequest(
        entity: RentModel.entity(),
        sortDescriptors: [NSSortDescriptor(key: "toDate", ascending: false)]) var rents: FetchedResults<RentModel>
    @State private var selectedCar = CarModel.honda2010
    
    // MARK: Properties
    
    var clients: [Client] {
        return rents
            .filter { $0.car == selectedCar.rawValue }
            .compactMap {
            guard let client = $0.client, let payment = $0.payment?.money else { return nil }
                let from = $0.fromDate
                let to = $0.toDate
                return Client(name: client.completeName ?? "", from: DateUtil.shared.getStringDate(Date(timeIntervalSince1970: TimeInterval(from))), to: DateUtil.shared.getStringDate(Date(timeIntervalSince1970: TimeInterval(to))), daysNumber: DateUtil.shared.getNumberOfdays(Date(timeIntervalSince1970: TimeInterval(from)), Date(timeIntervalSince1970: TimeInterval(to))), amount: Int(truncating: payment))
        }
    }
    
    // MARK: SwiftUI Container
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $selectedCar, label: Text("Carro"), content: {
                        Text("Honda CRV 2000").tag(CarModel.honda2000)
                        Text("Honda CRV 2004").tag(CarModel.honda2004)
                        Text("Honda CRV 2010").tag(CarModel.honda2010)
                        Text("Nissan Xtrail").tag(CarModel.nissan)
                    })
                }
                
                Section(header: Text("Month")) {
                    ForEach(clients, id: \.self) { client in
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "person.circle")
                                    Text("\(client.name)")
                                        .bold()
                                }
                                
                                HStack {
                                    Image(systemName: "calendar.badge.clock")
                                        .padding(.top, 5)
                                    
                                    Text("\(client.daysNumber) días")
                                        .padding(.top, 5)
                                }
                                .padding(.top, 1)
                                
                                HStack {
                                    Image(systemName: "calendar.circle")
                                    
                                    Text("\(client.from)")
                                }
                                
                                HStack {
                                    Image(systemName: "calendar.circle.fill")

                                    Text("\(client.to)")
                                }
                            }

                            Spacer()
                            
                            Text("₡\(client.amount)")
                                .bold()
                        }
                    }
                }
            }
            .navigationBarTitle("Historial de Alquileres")
        }
    }
}

struct RentHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        RentHistoryView()
    }
}
