//
//  BarChartXAxisGrid.swift
//  
//
//  Created by Eric on 2023/3/20.
//

import SwiftUI

internal struct BarChartXAxisGrid: ViewModifier {
   
   @ObservedObject private var chartData: BarChartData
   
   internal init(chartData: BarChartData) {
       self.chartData = chartData
   }
   
   internal func body(content: Content) -> some View {
       ZStack {
           if chartData.isGreaterThanTwo() {
               HStack(spacing: 0.0) {
                   ForEach(chartData.dataSets.dataPoints) { point in
                       HStack(spacing: 0.0) {
                           Spacer()
                               .frame(minWidth: 0, maxWidth: 500)
                           VerticalGridView(chartData: chartData)
                               .opacity(point.showsXAxisGridLine ? 1 : 0)
                           Spacer()
                               .frame(minWidth: 0, maxWidth: 500)
                       }
                   }
               }
               content
           } else { content }
       }
   }
}

extension View {
   public func barChartXAxisGrid(chartData: BarChartData) -> some View {
       self.modifier(BarChartXAxisGrid(chartData: chartData))
   }
}
