//
//  GraphView.swift
//  HelloCoreData_Mac
//
//  Created by taka2018 on 2018/12/28.
//  Copyright © 2018 taka2018. All rights reserved.
//

import Cocoa

class GraphView: NSView {
//    var context = NSGraphicsContext()
//    var context: CGContext = CGContext()
    var isDark: Bool = true
    
    var myPoint: NSPoint = NSPoint(x: 100, y: 100)
    
    var mColor: NSColor = NSColor.white

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
//        context = NSGraphicsContext.current?.cgContext
        

        var backgroundColor = NSColor.white
        if isDark {
            backgroundColor = NSColor.darkGray
        }
        
        backgroundColor.set()
        NSBezierPath.fill(bounds)
        
//        NSColor.blue.set()
        mColor = NSColor.gray
        mColor.set()
        let path = NSBezierPath()
        path.move(to: NSPoint(x: 0, y: 0))
        path.line(to: NSPoint(x: bounds.width, y: bounds.height))
//        path.stroke()
        
        //draw Line
//        drawLine(fromPos: NSPoint(x: 100, y: 100), toPos: NSPoint(x: 150,y: 150))
//        drawLine(fromPos: NSPoint(x: 150,y: 150), toPos: NSPoint(x: 200,y: 100))
        
        
        var i = 0
        while i <= (Int)(bounds.height / 100) {
            drawLine(fromPos: NSPoint(x: 0, y: 0 + 100 * i), toPos: NSPoint(x: (Int)(bounds.width), y: 100 * i), color: mColor)
            i += 1
        }
        
        i = 0
        while i <= (Int)(bounds.width / 100) {
            drawLine(fromPos: NSPoint(x: 0 + 100 * i, y: 0), toPos: NSPoint(x: 100 * i, y: (Int)(bounds.height)), color: mColor)
            i += 1
        }
        
        //draw Circle
//        drawCircle(center: NSPoint(x: 100, y: 100), radius: 5)
//        drawCircle(center: NSPoint(x: 150,y: 150), radius: 5)
//        drawCircle(center: NSPoint(x: 200,y: 100), radius: 5)
//        drawCircle2()
        
        drawRect(p0: NSPoint(x: 0, y: 0), p1: NSPoint(x: (Int)(bounds.width), y: (Int)(bounds.height)))
        
        drawCandle(prices: StockData.prices2)
//        let priceUp = Price(name: "N225", date: "2018-12-21", begin: "100", high: "200", low: "50", end: "150")
//        drawCandle(price: priceUp)
//
//        let priceDown = Price(name: "N225", date: "2018-12-21", begin: "150", high: "200", low: "50", end: "100")
//        drawCandle(price: priceDown)
    }
    
    //draw Line
    func drawLine(fromPos: NSPoint, toPos: NSPoint, color: NSColor) {
//        NSColor.darkGray.set()
        color.set()
        let path = NSBezierPath()
        path.move(to: fromPos)
        path.line(to: toPos)
        path.stroke()
    }
    
    //draw Circle
    func drawCircle(center: NSPoint, radius: CGFloat) {
        NSColor.green.set()
        let context = NSGraphicsContext.current?.cgContext
        let x0 = center.x - radius
        let y0 = center.y - radius
        let rect = CGRect.init(x: x0, y: y0, width: radius * 2, height: radius * 2)
        context?.addEllipse(in: rect)
        context?.fillPath()
        context?.strokePath()
    }
    
    //draw Circle
    func drawCircle2() {
        NSColor.green.set()
        let context = NSGraphicsContext.current?.cgContext
        
        let center = StockData.myPoint
        let radius: CGFloat = 50
        let x0 = center.x - radius
        let y0 = center.y - radius
        let rect = CGRect.init(x: x0, y: y0, width: radius * 2, height: radius * 2)
        context?.addEllipse(in: rect)
        context?.fillPath()
        context?.strokePath()
    }
    
    //draw Rect
    func drawRect(p0:NSPoint, p1:NSPoint) {
        NSColor.yellow.set()
        let context = NSGraphicsContext.current?.cgContext
        let rect = CGRect.init(x: p0.x, y: p0.y, width: abs(p0.x - p1.x), height: abs(p0.y - p1.y))
        context?.addRect(rect)
        context?.strokePath()
    }
    
    //draw Candle
//    func drawCandle(price: Price) {
    //        let begin = price.begin
    //        let end = price.end
    //        let high = price.high
    //        let low = price.low
    
    func drawCandle(prices: [Price]) {
        if prices.count == 0 {
            return
        }
        let context = NSGraphicsContext.current?.cgContext
        
        var maxValue = 0
        var minValue = Int(prices[0].low)!
        var n = 0
        if prices.count > 1 {
        while (n < 60) {
            if maxValue < Int(prices[n].high)! {
                maxValue = Int(prices[n].high)!
            }
            if minValue > Int(prices[n].low)! {
                minValue = Int(prices[n].low)!
            }
            n += 1
        }
        } else {
           return
        }
    
        let ratioY = Double(maxValue - minValue) / (Double)(bounds.height) * 1.2 //500.0 * 1.2
        print("ratio =: \(ratioY)")
        print("maxValue =: \(maxValue)")
        print("minValue =: \(minValue)")
        
        n = 0
        for price in prices {
            let begin = price.begin
            let end = price.end
            let high = price.high
            let low = price.low

            let width = 10
            var x0 = 0
            var y0 = 0
            var x1 = 0
            var y1 = 0
            
//            let maxY = price.high.max()
//            let minY = price.low.min()
//            print("\(String(describing: maxY)), \(minY)")
            
            let offsetX = 20
            var offsetY = -23600 //50 //700//-23800 //50
            offsetY = -minValue
            
            
            
            if begin < end {
                x0 = 0
                y0 = Int(begin)!
                x1 = x0 + width
                y1 = Int(end)!
//                NSColor.red.set()
                mColor = NSColor.red
                mColor.set()
            } else {
                x0 = 0
                y0 = Int(end)!
                x1 = x0 + width
                y1 = Int(begin)!
//                NSColor.blue.set()
                mColor = NSColor.blue
                mColor.set()
            }
            
            let rect = CGRect.init(x: x0 + offsetX * n, y: Int(Double(y0 + offsetY)/ratioY), width: width, height: Int(Double(y1 - y0) / ratioY))
            context?.addRect(rect)
            context?.fillPath()
            let upBranch1 = NSPoint(x: x0 + offsetX * n + width / 2, y: Int(Double(y1 + offsetY)/ratioY))
            let upBranch2 = NSPoint(x: x0 + offsetX * n + width / 2, y: Int(Double(Int(high)! + offsetY)/ratioY))
            let downBranch1 = NSPoint(x: x0 + offsetX * n + width / 2, y: Int(Double(y0 + offsetY)/ratioY))
            let downBranch2 = NSPoint(x: x0 + offsetX * n + width / 2, y: Int(Double(Int(low)! + offsetY)/ratioY))
            drawLine(fromPos: upBranch1, toPos: upBranch2, color: mColor)
            drawLine(fromPos: downBranch1, toPos: downBranch2, color: mColor)
            
            n += 1
        }
    }
    
    var prices = [
//        Price(name: "N225", date: "2018-12-21", begin: "100", high: "200", low: "70", end: "150"),
//        Price(name: "N225", date: "2018-12-21", begin: "200", high: "200", low: "70", end: "150"),
//        Price(name: "N225", date: "2018-12-25", begin: "300", high: "200", low: "70", end: "150"),
//        Price(name: "N225", date: "2018-12-25", begin: "400", high: "200", low: "70", end: "150"),
//        Price(name: "N225", date: "2018-12-25", begin: "500", high: "200", low: "70", end: "150"),
//        Price(name: "N225", date: "2018-12-25", begin: "600", high: "200", low: "70", end: "150"),
        Price(name: "N225", date: "2018-01-04", begin: "23770", high: "24150", low: "23770", end: "24150"),
        Price(name: "N225", date: "2018-01-05", begin: "24280", high: "24390", low: "24170", end: "24370"),
        Price(name: "N225", date: "2018-01-09", begin: "24650", high: "24650", low: "24450", end: "24510"),
        Price(name: "N225", date: "2018-01-10", begin: "24490", high: "24520", low: "24410", end: "24440"),
        Price(name: "N225", date: "2018-01-11", begin: "24330", high: "24400", low: "24250", end: "24360"),
        Price(name: "N225", date: "2018-01-12", begin: "24410", high: "24410", low: "24240", end: "24310"),
        Price(name: "N225", date: "2018-01-15", begin: "24460", high: "24490", low: "24340", end: "24370"),
        Price(name: "N225", date: "2018-01-16", begin: "24390", high: "24620", low: "24350", end: "24610"),
        Price(name: "N225", date: "2018-01-17", begin: "24430", high: "24550", low: "24400", end: "24530"),
        Price(name: "N225", date: "2018-01-18", begin: "24770", high: "24780", low: "24360", end: "24430"),
    ]
    let values: [String] = [
        "2018-01-04","770","150","770","1150","611004","24150",
        "2018-01-05","1280","1390","1170","1370","495513","24370",
//        "2018-01-04","23770","24150","23770","24150","611004","24150",
//        "2018-01-05","24280","24390","24170","24370","495513","24370",
//        "2018-01-09","24650","24650","24450","24510","363084","24510",
//        "2018-01-10","24490","24520","24410","24440","221450","24440",
//        "2018-01-11","24330","24400","24250","24360","710369","24360",
//        "2018-01-12","24410","24410","24240","24310","383357","24310",
//        "2018-01-15","24460","24490","24340","24370","193839","24370",
//        "2018-01-16","24390","24620","24350","24610","258414","24610",
//        "2018-01-17","24430","24550","24400","24530","255050","24530",
//        "2018-01-18","24770","24780","24360","24430","559985","24430"
    ]
}
