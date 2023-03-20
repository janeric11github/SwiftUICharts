//
//  XAxisGrid.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

public enum XAxisGridDistribution {
    case equalSpacing, equalProportion
}
/**
 Adds vertical lines along the X axis.
 */
internal struct XAxisGrid<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    let distribution: XAxisGridDistribution
    
    internal init(chartData: T, distribution: XAxisGridDistribution) {
        self.chartData = chartData
        self.distribution = distribution
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            if chartData.isGreaterThanTwo() {
                switch distribution {
                case .equalSpacing:
                    HStack(spacing: 0.0) {
                        ForEach((0...chartData.chartStyle.xAxisGridStyle.numberOfLines-1), id: \.self) { index in
                            VerticalGridView(chartData: chartData)
                            if index != chartData.chartStyle.xAxisGridStyle.numberOfLines-1 {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                case .equalProportion:
                    HStack(spacing: 0.0) {
                        ForEach((0...chartData.chartStyle.xAxisGridStyle.numberOfLines-1), id: \.self) { index in
                            HStack(spacing: 0.0) {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                                VerticalGridView(chartData: chartData)
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                }
                content
            } else { content }
        }
    }
}

extension View {
    /**
     Adds vertical lines along the X axis.
     
     The style is set in ChartData --> ChartStyle --> xAxisGridStyle
     
     - Requires:
     Chart Data to conform to CTLineBarChartDataProtocol.
     
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Filled Line Chart
     - Ranged Line Chart
     - Bar Chart
     - Grouped Bar Chart
     - Stacked Bar Chart
     - Ranged Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with vertical lines under it.
     */
    public func xAxisGrid<T: CTLineBarChartDataProtocol>(
        chartData: T,
        distribution: XAxisGridDistribution = .equalSpacing) -> some View
    {
        self.modifier(XAxisGrid(chartData: chartData, distribution: distribution))
    }
}
