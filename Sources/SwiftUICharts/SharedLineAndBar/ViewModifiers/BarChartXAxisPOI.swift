//
//  BarChartXAxisPOI.swift
//  
//
//  Created by Eric on 2023/3/20.
//

import SwiftUI

internal struct BarChartXAxisPOI: ViewModifier {
    private let uuid: UUID = UUID()
    
    @ObservedObject private var chartData: BarChartData
    private let indices: [Int]
    
    private let lineColour: Color
    private let strokeStyle: StrokeStyle
    private let pointStyle: PointStyle
    
    internal init(
        chartData: BarChartData,
        indices: [Int],
        lineColour: Color,
        strokeStyle: StrokeStyle,
        pointStyle: PointStyle
    ) {
        self.chartData = chartData
        self.indices = indices
        self.lineColour = lineColour
        self.strokeStyle = strokeStyle
        self.pointStyle = pointStyle
    }
    
    @State private var startAnimation: Bool = false
    
    internal func body(content: Content) -> some View {
        ZStack {
            if chartData.isGreaterThanTwo() {
                content
                if !indices.isEmpty {
                    var remaining = indices
                    let first = remaining.removeFirst()
                    
                    line(index: first)
                        .animateOnAppear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
                        .animateOnDisappear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = false
                        }
                    point(index: first)
                    
                    ForEach(remaining, id: \.self) { index in
                        line(index: index)
                        point(index: index)
                    }
                }
            } else { content }
        }
    }
    
    private func line(index: Int) -> some View {
        BarChartVerticalAbscissaMarker(chartData: chartData, index: index)
            .trim(to: animationValue)
            .stroke(lineColour, style: strokeStyle)
    }
    
    private func point(index: Int) -> some View {
        BarChartPointMarker(
            chartData: chartData,
            index: index,
            radius: pointStyle.pointSize / 2)
        .stroke(
            pointStyle.borderColour,
            lineWidth: pointStyle.lineWidth)
        .opacity(animationValue)
        .background(
            BarChartPointMarker(
                chartData: chartData,
                index: index,
                radius: pointStyle.pointSize / 2)
            .foregroundColor(pointStyle.fillColour)
            .opacity(animationValue)
        )
    }
    
    var animationValue: CGFloat {
        if chartData.disableAnimation {
            return 1
        } else {
            return startAnimation ? 1 : 0
        }
    }
}

extension View {
    public func barChartXAxisPOI(
        chartData: BarChartData,
        indices: [Int],
        lineColour: Color = Color(.blue),
        strokeStyle: StrokeStyle = StrokeStyle(
            lineWidth: 2,
            lineCap: .round,
            lineJoin: .round,
            miterLimit: 10,
            dash: [CGFloat](),
            dashPhase: 0),
        pointStyle: PointStyle = PointStyle()
    ) -> some View {
        self.modifier(BarChartXAxisPOI(
            chartData: chartData,
            indices: indices,
            lineColour: lineColour,
            strokeStyle: strokeStyle,
            pointStyle: pointStyle))
    }
}
