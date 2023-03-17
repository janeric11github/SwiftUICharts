//
//  InfoBox.swift
//  
//
//  Created by Will Dale on 15/02/2021.
//

import SwiftUI

// MARK: Vertical
/**
 A view that displays information from `TouchOverlay`.
 */
internal struct InfoBox<T, V>: ViewModifier where T: CTLineBarChartDataProtocol, V: View {
    
    @State private var boxFrame: CGRect = .zero
    @ObservedObject private var chartData: T
    private let height: CGFloat
    private let customBox: ((T.DataPoint) -> V)?
    
    internal init(
        chartData: T,
        height: CGFloat,
        customBox: ((T.DataPoint) -> V)? = nil
    ) {
        self.chartData = chartData
        self.height = height
        self.customBox = customBox
    }
    
    internal func body(content: Content) -> some View {
        Group {
            switch chartData.chartStyle.infoBoxPlacement {
            case .floating:
                content
            case .infoBox(let isStatic):
                switch isStatic {
                case true:
                    VStack(spacing: 0) {
                        fixed
                        content
                    }
                case false:
                    VStack(spacing: 0) {
                        floating
                        content
                    }
                }
            case .header:
                content
            }
        }
    }
    
    private var floating: some View {
        TouchOverlayBox(chartData: chartData,
                        boxFrame: $boxFrame,
                        content: customBox)
        .position(
            x: chartData.setBoxLocation(
                touchLocation: chartData.infoView.touchLocation.x,
                boxFrame: boxFrame,
                chartSize: chartData.infoView.chartSize),
            y: height / 2)
        .frame(height: height)
        .zIndex(1)
    }
    
    private var fixed: some View {
        TouchOverlayBox(chartData: chartData,
                        boxFrame: $boxFrame,
                        content: customBox)
            .frame(height: height)
            .zIndex(1)
    }
}

// MARK: Horizontal
/**
 A view that displays information from `TouchOverlay`.
 */
internal struct HorizontalInfoBox<T>: ViewModifier where T: CTLineBarChartDataProtocol & isHorizontal {
    
    @ObservedObject private var chartData: T
    private let width: CGFloat
    
    internal init(
        chartData: T,
        width: CGFloat
    ) {
        self.chartData = chartData
        self.width = width
    }
    
    @State private var boxFrame: CGRect = CGRect(x: 0, y: 0, width: 70, height: 0)
    
    internal func body(content: Content) -> some View {
        Group {
            switch chartData.chartStyle.infoBoxPlacement {
            case .floating:
                content
            case .infoBox(let isStatic):
                switch isStatic {
                case true:
                    HStack {
                        content
                        fixed
                    }
                case false:
                    HStack {
                        content
                        floating
                    }
                }
            case .header:
                content
            }
        }
    }
    
    private var floating: some View {
        TouchOverlayBox(chartData: chartData,
                        boxFrame: $boxFrame,
                        content: { _ in EmptyView() })
            .position(x: 35,
                      y: chartData.setBoxLocation(touchLocation: chartData.infoView.touchLocation.y,
                                                       boxFrame: boxFrame,
                                                       chartSize: chartData.infoView.chartSize))
            .frame(width: width)
            .zIndex(1)
    }
    
    private var fixed: some View {
        TouchOverlayBox(chartData: chartData,
                        boxFrame: $boxFrame,
                        content: { _ in EmptyView() })
            .frame(width: width)
            .zIndex(1)
    }
}
extension View {
    /**
     A view that displays information from `TouchOverlay`.
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with a view to
     display touch overlay information.
     */
    public func infoBox<T: CTLineBarChartDataProtocol, V: View>(
        chartData: T,
        height: CGFloat = 70,
        customBox: ((T.DataPoint) -> V)? = nil
    ) -> some View {
        self.modifier(InfoBox(chartData: chartData, height: height, customBox: customBox))
    }

    /**
     A view that displays information from `TouchOverlay`.
     
     - Parameters:
        - chartData: Chart data model.
        - width: Width of the view.
     - Returns: A  new view containing the chart with a view to
     display touch overlay information.
     */
    public func infoBox<T: CTLineBarChartDataProtocol & isHorizontal>(
        chartData: T,
        width: CGFloat = 70
    ) -> some View {
        self.modifier(HorizontalInfoBox(chartData: chartData, width: width))
    }
}
