//
//  MainView.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 30/12/20.
//

import SwiftUI

struct MainView: View {
    // MARK: - SwiftUI Container
    
    var body: some View {
        TabView {
            DashBoardView()
                .tabItem {
                    Image(systemName: "squareshape.dashed.squareshape")
                    Text("Dashboard")
                }
            
            RentHistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("Historial")
                }
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Estadisticas")
                }
            
            ScheduleView()
                .tabItem {
                    Image(systemName: "calendar.badge.plus")
                    Text("Agendar")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
