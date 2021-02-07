//
//  DateTimeView.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 7/2/21.
//

import SwiftUI

struct DateTimeView: View {
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
    
    var hour: String {
        return date[3]
    }
    
    var minute: String {
        return date[4]
    }
    
    var period: String {
        guard let hour = Int(self.hour) else { return "" }
        return hour > 12 ? "PM" : "AM"
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(weekName)
                .font(.callout)
                .foregroundColor(.red)
                .padding(.leading, 8)
            
            HStack {
                VStack {
                    Text(day)
                        .font(.system(size: 25))
                        .bold()
                    Text(month)
                        .font(.caption)
                }
                
                VStack {
                    Text("\(hour) : \(minute)")
                        .font(.system(size: 25))
                        .bold()
                    Text(period)
                        .font(.caption)
                }
            }
        }
    }
    
    init(_ date: Date) {
        self.date = DateUtil.shared.getDateComponents(date, formatter: "EEEE,d,MMMM,h,mm")
    }
}

struct DateTimeView_Previews: PreviewProvider {
    static var previews: some View {
        DateTimeView(Date())
    }
}
