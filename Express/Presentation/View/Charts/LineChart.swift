//
//  LineChart.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 14/3/21.
//

import SwiftUI

struct LineChart: Shape {
    var dataPoints: [CGFloat]

    func path(in rect: CGRect) -> Path {
        func point(at ix: Int) -> CGPoint {
            let point = dataPoints[ix]
            let x = rect.width * CGFloat(ix) / CGFloat(dataPoints.count - 1) - 2.5
            let y = (1-point) * rect.height
            return CGPoint(x: x, y: y)
        }
        
        func point2(at ix: Int) -> CGPoint {
            var a: CGFloat = 0.0
            if ix != 0 || ix != (dataPoints.count - 1) {
                a = 2.5
            } else {
                
            }
            let point = dataPoints[ix]
            let x = rect.width * CGFloat(ix) / CGFloat(dataPoints.count - 1) - a
            let y = (1-point) * rect.height - 2.5
            return CGPoint(x: x, y: y)
        }

        return Path { p in
            guard dataPoints.count > 1 else { return }
//            let start = dataPoints[0]
//            p.move(to: CGPoint(x: 0, y: (1-start) * rect.height))
            for idx in dataPoints.indices {
                p.addLine(to: point(at: idx))
                p.addEllipse(in: CGRect(origin: point2(at: idx), size: CGSize(width: 5, height: 5)))
            }
        }
    }
}
