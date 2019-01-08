//
//  ViewController.swift
//  HelloCoreData_Mac
//
//  Created by taka2018 on 2018/12/22.
//  Copyright © 2018 taka2018. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
//    @IBOutlet weak var tableView: NSScrollView!
//    @IBOutlet weak var tableView2: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var graphView: GraphView!
    
    var persons = [
        Person(name: "Yamada", age: 22),
        Person(name: "Tanaka", age: 32)
    ]
    
    var prices = [
        Price(name: "N225", date: "2018-12-21", begin: "20,310.50", high: "20,334.73", low: "20,006.67", end: "20,166.19"),
//        Price(name: "N225", date: "2018-12-25", begin: "20000", end: "20000", high: "20000", low: "20000"),
//        Price(name: "N225", date: "2018-12-25", begin: "20000", end: "20000", high: "20000", low: "20000"),
//        Price(name: "N225", date: "2018-12-25", begin: "20000", end: "20000", high: "20000", low: "20000"),
//        Price(name: "N225", date: "2018-12-25", begin: "20000", end: "20000", high: "20000", low: "20000"),
//        Price(name: "N225", date: "2018-12-25", begin: "20000", end: "20000", high: "20000", low: "20000"),
//        Price(name: "N225", date: "2018-12-25", begin: "20000", end: "20000", high: "20000", low: "20000"),
//        Price(name: "N225", date: "2018-12-25", begin: "20000", end: "20000", high: "20000", low: "20000"),
//        Price(name: "N225", date: "2018-12-25", begin: "20000", end: "20000", high: "20000", low: "20000")
    ]
    
    var stockPrices: [Price] = []
    
    
    let data1 = ["1", "2", "3"]
    let data2 = ["11", "12", "13"]
    let data3 = ["21", "22", "23"]
    let data4 = ["31", "32", "33"]
    
    var dates: [[String]] = []
    
    
    var fileDataLines: [[String]] = []
    
//    @IBOutlet weak var stockName: NSTextField!
//    @IBOutlet weak var stockId: NSTextField!
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func createButton(_ sender: Any) {
        createData()
    }
    @IBAction func readButton(_ sender: Any) {
        readData()
    }
    @IBAction func deleteButton(_ sender: Any) {
        deleteData()
    }
    @IBAction func updateButton(_ sender: Any) {
        updateData()
    }
    @IBAction func readCSV(_ sender: Any) {
        readFile()
    }
    @IBAction func printcsv(_ sender: Any) {
        
        for i in stride (from: 2, to: stockPrices.count, by: 1)  {
//            print(fileDataLines[i])
            print("[\(i)] : \(stockPrices[i].date)")
            print("[\(i)] : \(stockPrices[i].begin)")
            print("[\(i)] : \(stockPrices[i].high)")
            print("[\(i)] : \(stockPrices[i].low)")
            print("[\(i)] : \(stockPrices[i].end)")
        }
        tableView.reloadData()
//        graphView.prices = stockPrices
//        graphView.display()
//        graphView.drawCircle(center: NSPoint(x: 100, y: 100), radius: 5)
//        graphView.drawCandle(prices: stockPrices)
    }
    @IBAction func drawGraph(_ sender: NSButton) {
//        StockData.myPoint = NSPoint(x: 200, y: 200)
        graphView.display()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func readFile() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
//        openPanel.allowedFileTypes = NSImage.imageTypes()
        openPanel.begin(completionHandler:
            { (result) -> Void in
                
            if result == NSApplication.ModalResponse.OK {
                guard let url = openPanel.url else {return}
                print(url.absoluteString)
                
                var csvString = ""
                var csvArr: [String] = []
                var dataArr: [String] = []
                
                StockData.prices2.removeAll()
                
                do {
                    csvString = try NSString(contentsOf: url, encoding: String.Encoding.shiftJIS.rawValue) as String
                    csvArr = csvString.components(separatedBy: .newlines)
                    print(csvArr)
                    
                    for index in 2...(csvArr.count - 1) {
                        dataArr = csvArr[index].components(separatedBy: ",")
                        let price = Price(name: "", date: "", begin: "", high: "", low: "", end: "")
                        
                        //normal
                        price.date = self.omitQuotation(string: dataArr[0])
                        price.begin = self.omitQuotation(string: dataArr[1])
                        price.high = self.omitQuotation(string: dataArr[2])
                        price.low = self.omitQuotation(string: dataArr[3])
                        price.end = self.omitQuotation(string: dataArr[4])
                        //for nikkei225 data
//                        price.date = self.omitQuotation(string: dataArr[0])
//                        price.begin = self.omitQuotation(string: dataArr[2])
//                        price.high = self.omitQuotation(string: dataArr[3])
//                        price.low = self.omitQuotation(string: dataArr[4])
//                        price.end = self.omitQuotation(string: dataArr[1])
                        print(price.date)
                        print(price.begin)
                        print(price.high)
                        print(price.low)
                        print(price.end)
                        
                        self.stockPrices.append(price)
                        
                        StockData.prices2.append(price)
                    }
                    
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        })
    }

    //文字列から'"'を削除する
    func omitQuotation(string: String) -> String {
        let newString = string.replacingOccurrences(of: "\"", with: "")
        return newString
    }
    
    func createData() {
        //get delegate
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        //get context
        let managedContext = appDelegate.persistentContainer.viewContext
        //get entity
        let stockEntity = NSEntityDescription.entity(forEntityName: "Stocks", in: managedContext)
        
        for i in 1...5 {
            let newUser = NSManagedObject(entity: stockEntity!, insertInto: managedContext)
            newUser.setValue("Ichi\(i)", forKey: "name")
            newUser.setValue("000\(i)", forKey: "idNumber")
        }
        do {
            try managedContext.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func readData() {
        //get delegate
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        //get context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
//        let fetchRequest =
//            NSFetchRequest<NSManagedObject>(entityName: "Stocks")
//        //3
//        do {
//            let result = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
        
        //fetch request
        let request: NSFetchRequest<Stocks> = Stocks.fetchRequest()
        let name = "Ichi?"
        request.predicate = NSPredicate(format: "name LIKE %@", name)
//        request.predicate = NSPredicate(format: "idNumber CONTAINS %@", "002")
        
        do {
            let result = try managedContext.fetch(request)
            for data in result {
                
                
//                print(data.value(forKey: "name") as! String)
//                print(data.value(forKey: "idNumber") as! String)
                print(data.name!)
                print(data.idNumber!)
                
//                stockName.stringValue = data.value(forKey: "name") as! String
//                stockId.stringValue = data.value(forKey: "idNumber") as! String
            }
        } catch  {
            print("Failed")
        }
    }
    
    func updateData() {
        //get delegate
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        //get context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //fetch request
        let request: NSFetchRequest<Stocks> = Stocks.fetchRequest()
        
        do {
            let fetchResult = try managedContext.fetch(request)
            for result in fetchResult {
                let record = result as NSManagedObject
                record.setValue("Taro", forKey: "name")
                record.setValue("1234", forKey: "idNumber")
            }
            try managedContext.save()
        } catch  {
            print("Failed")
        }
    }
    
    func deleteData() {
        //get delegate
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        //get context
        let managedContext = appDelegate.persistentContainer.viewContext
        //fetch request
        let request: NSFetchRequest<Stocks> = Stocks.fetchRequest()
        
        do {
            let fetchResult = try managedContext.fetch(request)
            
            for result in fetchResult {
                let record = result as NSManagedObject
                managedContext.delete(record)
            }
            try managedContext.save()
        } catch  {
            print(error)
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
//        return prices.count
        return stockPrices.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        //Storyboard: Content Mode->Cell Based
        if tableColumn?.title == "date"{
//            return prices[row].date
            return stockPrices[row].date
        } else if tableColumn?.title == "begin" {
//            return prices[row].begin
            return stockPrices[row].begin
        } else if tableColumn?.title == "end"{
//            return prices[row].end
            return stockPrices[row].end
        } else if tableColumn?.title == "high" {
//            return prices[row].high
            return stockPrices[row].high
        } else if tableColumn?.title == "low" {
//            return prices[row].low
            return stockPrices[row].low
        }
        return nil
    }
    
}

extension String {
    var lines: [String] {
        var lines = [String]()
        self.enumerateLines(invoking: {(line, stop) -> () in
            lines.append(line)
        })
        return lines
    }

}

