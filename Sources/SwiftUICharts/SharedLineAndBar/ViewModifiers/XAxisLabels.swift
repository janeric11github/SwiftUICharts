//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

/**
 Labels for the X axis.
 */
internal struct XAxisLabels<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    private let padding: CGFloat
    
    internal init(chartData: T, padding: CGFloat) {
        self.chartData = chartData
        self.padding = padding
        self.chartData.viewData.hasXAxisLabels = true
        self.chartData.viewData.xAxisLabelPadding = padding
    }
    
    internal func body(content: Content) -> some View {
        Group {
            switch chartData.chartStyle.xAxisLabelPosition {
            case .bottom:
                if chartData.isGreaterThanTwo() {
                    VStack(spacing: 0) {
                        content
                        chartData.getXAxisLabels().padding(.top, padding)
                        chartData.getXAxisTitle()
                    }
                } else { content }
            case .top:
                if chartData.isGreaterThanTwo() {
                    VStack(spacing: 0) {
                        chartData.getXAxisTitle()
                        chartData.getXAxisLabels().padding(.bottom, padding)
                        content
                    }
                } else { content }
            }
        }
    }
}

extension View {
    /**
     Labels for the X axis.
     
     The labels can either come from ChartData -->  xAxisLabels
     or ChartData --> DataSets --> DataPoints
     
     - Requires:
     Chart Data to conform to CTLineBarChartDataProtocol.
     
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
     - Returns: A  new view containing the chart with labels marking the x axis.
     */
    public func xAxisLabels<T: CTLineBarChartDataProtocol>(
        chartData: T,
        padding: CGFloat = 2
    ) -> some View {
        self.modifier(XAxisLabels(chartData: chartData, padding: padding))
    }
}
