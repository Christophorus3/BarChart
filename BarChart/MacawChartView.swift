//
//  MacawChartView.swift
//  BarChart
//
//  Created by Christoph Wottawa on 30.05.19.
//  Copyright © 2019 Christoph Wottawa. All rights reserved.
//

import Foundation
import Macaw

class MacawChartView: MacawView {
    
    static let lastFiveShows = createDummyData()
    static let maxValue = 1200
    static let maxValueLineHeight = 180
    static let lineWidth: Double = 275
    
    static let dataDivisor = Double(maxValue / maxValueLineHeight)
    static let adjustedData: [Double] = lastFiveShows.map({ $0.viewCount / dataDivisor })
    static var animations: [Animation] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(node: MacawChartView.createChart(), coder: aDecoder)
        
        backgroundColor = .clear
        
    }
    
    private static func createChart() -> Group {
        var items: [Node] = addXAxisItems() + addYAxisItems()
        items.append(createBars())
        return Group(contents: items, place: .identity)
    }
    
    private static func addXAxisItems() -> [Node] {
        let chartBaseY: Double = 200
        var newNodes: [Node] = []
        
        for i in 1...adjustedData.count {
            let x = Double(i) * 50
            let valueText = Text(text: lastFiveShows[i - 1].name, align: .max, baseline: .mid, place: .move(dx: x, dy: chartBaseY + 15))
            valueText.fill = Color.black
            newNodes.append(valueText)
        }
        
        let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.black.with(a: 0.25))
        newNodes.append(xAxis)
        
        return newNodes
    }
    
    private static func addYAxisItems() -> [Node] {
        let maxLines = 6
        let lineInterval = Int(maxValue/maxLines)
        let yAxisHeight: Double = 200
        let lineSpacing: Double = 30
        
        var newNodes: [Node] = []
        
        for i in 1...maxLines {
            let y = yAxisHeight - (Double(i) * lineSpacing)
            
            let valueLine = Line(x1: 0, y1: y, x2: lineWidth, y2: y)
                .stroke(fill: Color.black.with(a: 0.10))
            let valueText = Text(text: "\(i * lineInterval)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y))
            valueText.fill = Color.black
            
            newNodes.append(valueLine)
            newNodes.append(valueText)
        }
        
        let yAxis = Line(x1: 0, y1: 0, x2: 0, y2: yAxisHeight).stroke(fill: Color.black.with(a: 0.25))
        newNodes.append(yAxis)
        
        return newNodes
    }
    
    private static func createBars() -> Group {
        let fill = LinearGradient(degree: 90, from: Color(val: 0xff4704), to: Color(val: 0xff4704).with(a: 0.33))
        let items = adjustedData.map {_ in Group()}
        
        animations = items.enumerated().map { (i: Int, item: Group) in
            item.contentsVar.animation(delay: Double(i) * 0.1) { t in
                let height = adjustedData[i] * t
                let rect = Rect(x: Double(i) * 50 + 25, y: 200 - height, w: 30, h: height)
                return [rect.fill(with: fill)]
            }
        }
        return items.group()
    }
    
    static func playAnimations() {
        animations.combine().play()
    }
    
    private static func createDummyData() -> [YoutubeVideo]{
        let one = YoutubeVideo(name: "One", viewCount: 225)
        let two = YoutubeVideo(name: "Two", viewCount: 376)
        let three = YoutubeVideo(name: "Three", viewCount: 777)
        let four = YoutubeVideo(name: "Four", viewCount: 365)
        let five = YoutubeVideo(name: "Five", viewCount: 1003)
        
        return [one, two, three, four, five]
    }
}
