//
//  StatisticsView.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 14/3/21.
//

import SwiftUI

struct StatisticsView: View {
    @State private var selectedCar = CarModel.honda2010
    let sampleData: [CGFloat] = [0.2,0.5,0.6,0.2, 0.5, 0.3, 0.7, 0.2, 0.8]
    @State var on = false
    
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
                
                Section(header: Text("Por mes"), content: {
                    LineChart(dataPoints: sampleData)
                        .trim(to: on ? 1 : 0)
                        .stroke(Color.red, lineWidth: 2)
                        .aspectRatio(16/9, contentMode: .fit)
//                        .border(Color.gray, width: 1)
                        .padding()
                    
                    Button("Animate") {
                        withAnimation(.easeInOut(duration: 2)) {
                            self.on.toggle()
                        }
                    }
                })
            }
            .navigationTitle("Estadisticas")
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
