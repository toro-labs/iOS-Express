//
//  DateView.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 7/2/21.
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
        .padding(.trailing, 10)
    }
    
    // MARK: Initializer
    
    init(_ date: Date) {
        self.date = DateUtil.shared.getDateComponents(date)
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView(Date())
    }
}
