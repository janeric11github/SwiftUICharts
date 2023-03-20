//
//  Marker.swift
//  
//
//  Created by Will Dale on 30/12/2020.
//

import SwiftUI

/// Generic line, drawn horizontally across the chart.
internal struct HorizontalMarker<ChartData>: Shape where ChartData: CTLineBarChartDataProtocol & PointOfInterestProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let value: Double
    private let range: Double
    private let minValue: Double
    
    internal init(
        chartData: ChartData,
        value: Double,
        range: Double,
        minValue: Double
    ) {
        self.chartData = chartData
        self.value = value
        self.range = range
        self.minValue = minValue
    }
    
    internal func path(in rect: CGRect) -> Path {
        let pointY: CGFloat = chartData.poiValueLabelPositionCenter(frame: rect, markerValue: value, minValue: minValue, range: range).y
        
        let firstPoint = CGPoint(x: 0, y: pointY)
        let nextPoint = CGPoint(x: rect.width, y: pointY)
        
        var path = Path()
        path.move(to: firstPoint)
        path.addLine(to: nextPoint)
        return path
    }
}

/// Generic line, drawn vertically across the chart.
internal struct VerticalMarker<ChartData>: Shape where ChartData: CTLineBarChartDataProtocol & PointOfInterestProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let value: Double
    private let range: Double
    private let minValue: Double
    
    internal init(
        chartData: ChartData,
        value: Double,
        range: Double,
        minValue: Double
    ) {
        self.chartData = chartData
        self.value = value
        self.range = range
        self.minValue = minValue
    }
    
    internal func path(in rect: CGRect) -> Path {
        let pointX: CGFloat = chartData.poiValueLabelPositionCenter(frame: rect, markerValue: value, minValue: minValue, range: range).x
        
        let firstPoint = CGPoint(x: pointX, y: 0)
        let nextPoint = CGPoint(x: pointX, y: rect.height)
        
        var path = Path()
        path.move(to: firstPoint)
        path.addLine(to: nextPoint)
        return path
    }
}


/// Generic line, drawn vertically across the chart.
internal struct VerticalAbscissaMarker<ChartData>: Shape where ChartData: CTLineBarChartDataProtocol & PointOfInterestProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let markerValue: Int
    private let dataPointCount: Int
    
    internal init(
        chartData: ChartData,
        markerValue: Int,
        dataPointCount: Int
    ) {
        self.chartData = chartData
        self.markerValue = markerValue
        self.dataPointCount = dataPointCount
    }
    
    internal func path(in rect: CGRect) -> Path {
        let pointX: CGFloat = chartData.poiAbscissaValueLabelPositionCenter(frame: rect, markerValue: markerValue, count: dataPointCount).x
        let firstPoint = CGPoint(x: pointX, y: 0)
        let nextPoint = CGPoint(x: pointX, y: rect.height)
        
        var path = Path()
        path.move(to: firstPoint)
        path.addLine(to: nextPoint)
        return path
    }
}

/// Generic line, drawn horizontally across the chart.
internal struct HorizontalAbscissaMarker<ChartData>: Shape where ChartData: CTLineBarChartDataProtocol & PointOfInterestProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let markerValue: Int
    private let dataPointCount: Int
    
    internal init(
        chartData: ChartData,
        markerValue: Int,
        dataPointCount: Int
    ) {
        self.chartData = chartData
        self.markerValue = markerValue
        self.dataPointCount = dataPointCount
    }
    
    internal func path(in rect: CGRect) -> Path {
        let pointY: CGFloat = chartData.poiAbscissaValueLabelPositionCenter(frame: rect, markerValue: markerValue, count: dataPointCount).y
        let firstPoint = CGPoint(x: 0, y: pointY)
        let nextPoint = CGPoint(x: rect.width, y: pointY)
        
        var path = Path()
        path.move(to: firstPoint)
        path.addLine(to: nextPoint)
        return path
    }
}

internal struct BarChartVerticalAbscissaMarker: Shape {
    @ObservedObject private var chartData: BarChartData
    private let index: Int
    
    internal init(
        chartData: BarChartData,
        index: Int
    ) {
        self.chartData = chartData
        self.index = index
    }
    
    internal func path(in rect: CGRect) -> Path {
        guard let point = getPoint(index: index, rect: rect) else { return Path() }
        
        var path = Path()
        path.move(to: .init(x: point.x, y: rect.height - chartData.chartStyle.yAxisGridStyle.lineWidth))
        path.addLine(to: .init(x: point.x, y: point.y))
        return path
    }
    
    private func getPoint(index: Int, rect: CGRect) -> CGPoint? {
        let dataPoints = chartData.dataSets.dataPoints
        let chartSize = rect.size
        let minValue = chartData.minValue
        let maxValue = chartData.maxValue
        guard index >= 0, index < dataPoints.count else { return nil }
        let value = dataPoints[index].value
        let xSection: CGFloat = chartSize.width / CGFloat(dataPoints.count)
        var ySection: CGFloat = chartSize.height / CGFloat(maxValue)
        let x = (CGFloat(index) * xSection) + (xSection / 2)
        var y = (chartSize.height - CGFloat(value) * ySection)
        if minValue.isLess(than: 0) {
            ySection = chartSize.height / (CGFloat(maxValue) - CGFloat(minValue))
            y = (chartSize.height - (CGFloat(value) * ySection) + (CGFloat(minValue) * ySection))
        }
        return CGPoint(x: x, y: y)
    }
}

internal struct BarChartPointMarker: InsettableShape {
    @ObservedObject private var chartData: BarChartData
    private let index: Int
    private let radius: CGFloat
    private var insetAmount: CGFloat = 0
    
    internal init(
        chartData: BarChartData,
        index: Int,
        radius: CGFloat
    ) {
        self.chartData = chartData
        self.index = index
        self.radius = radius
    }
    
    internal func path(in rect: CGRect) -> Path {
        guard let point = getPoint(index: index, rect: rect) else { return Path() }
        
        let insetRadius = radius - insetAmount
        
        var path = Path()
        path.addEllipse(in: .init(
            x: point.x - insetRadius,
            y: point.y - insetRadius,
            width: insetRadius * 2,
            height: insetRadius * 2))
        return path
    }
    
    private func getPoint(index: Int, rect: CGRect) -> CGPoint? {
        let dataPoints = chartData.dataSets.dataPoints
        let chartSize = rect.size
        let minValue = chartData.minValue
        let maxValue = chartData.maxValue
        guard index >= 0, index < dataPoints.count else { return nil }
        let value = dataPoints[index].value
        let xSection: CGFloat = chartSize.width / CGFloat(dataPoints.count)
        var ySection: CGFloat = chartSize.height / CGFloat(maxValue)
        let x = (CGFloat(index) * xSection) + (xSection / 2)
        var y = (chartSize.height - CGFloat(value) * ySection)
        if minValue.isLess(than: 0) {
            ySection = chartSize.height / (CGFloat(maxValue) - CGFloat(minValue))
            y = (chartSize.height - (CGFloat(value) * ySection) + (CGFloat(minValue) * ySection))
        }
        return CGPoint(x: x, y: y)
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var insetSelf = self
        insetSelf.insetAmount += amount
        return insetSelf
    }
}
