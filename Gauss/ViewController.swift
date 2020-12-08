//
//  Created by Mikhail Sergeev on 12.10.2020.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var size: NSPopUpButton!
    
    // MARK: - Private property
    
    private var matrixSize: [String : Int] = {
        var dictionary: [String : Int]=[:]
        (1...7).forEach({dictionary [String(String($0) + "x" + String($0))] = $0})
        return dictionary
    }()
    private var currentSize = 0
    private var arrayA: [NSTextField] = []
    private var arrayB: [NSTextField] = []
    private var result: [NSTextField] = []
    private var matrixA: [[Double]] = []
    private var matrixB: [Double] = []
    private var xForResult: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillSize()
        setCurrentSize()
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }

    override func viewDidAppear() {
        view.window?.title = "Gauss's Method"
        view.window?.styleMask = [.closable, .titled]
    }

    // MARK: - IBActions
    
    @IBAction func pushOpen(_ sender: NSButton) {
        // указываем путь к файлу
        let oPanel = NSOpenPanel()
        oPanel.runModal()
        guard let url = oPanel.urls.first else {
            return
        }
        
        // считываем данные из файла
        do {
            let data = try String(contentsOf: url)
            let matrix = data.components(separatedBy: "\n").compactMap({$0.split(separator: " ")}).compactMap({$0.compactMap({Double($0)})})
            // проверяем размер считанных данных
            let columns = matrix.first?.count
            let rows = matrix.count
            let changeColumns = matrix.map({$0.count == columns ? true : false})
            let isAllowed = changeColumns.filter({$0 == true}).count == rows
            // если размерности правильные, работаем дальше
            if isAllowed {
                // записываем данные из файла в переменные
                matrixB = matrix.compactMap({$0.last})
                matrixA = matrix.compactMap({$0.dropLast()})
                // устанавливаем текущее значение размера матрицы
                currentSize = matrixA.count
                // создаем графическую матрицу, заполненную из переменных matrixA matrixB
                createMatrix(fromFile: true, size: matrixA.count)
            } else {
                return
            }
        } catch {
            print(error.localizedDescription)
        }
               
    }
      
    @IBAction func pushSize(_ sender: NSPopUpButton) {
        setCurrentSize()
    }
    
    
    @IBAction func pushButton(_ sender: NSButton) {
        setCurrentSize()
        createMatrix(fromFile: false, size: currentSize)
    }
    
    @IBAction func pushStart(_ sender: NSButton) {
        
        guard checkMatrix() == true, !arrayA.isEmpty, !arrayB.isEmpty else {
            return
        }
        
        let prepare = PrepareMatrix(arrayA: arrayA, arrayB: arrayB, size: currentSize)
        prepare.prepareMatrix()
        let a = prepare.matrixA
        let b = prepare.matrixB
        
        let matrix = Matrix(matrixA: a, matrixB: b)
        matrix.gauss()
        let result = matrix.result
        
        createResult()
        zip(self.result, result).map({$0.stringValue = $1})

    }
    
    // MARK: - Private methods
    
    private func checkMatrix() -> Bool {
        for x in arrayA {
            if x.stringValue == "" {
                return false
            }
        }
        for b in arrayB {
            if b.stringValue == "" {
                return false
            }
        }
        return true
    }
    
    private func createMatrix(fromFile: Bool, size: Int) {
        
        let mSize = size
        
        arrayA.forEach({$0.removeFromSuperview()})
        arrayA = []
        arrayB.forEach({$0.removeFromSuperview()})
        arrayB = []
        result.forEach({$0.removeFromSuperview()})
        result = []
        
        let columns: Int = mSize
        let rows: Int = mSize + 1
        
        let widthMatrix     = rows*(widthCell + xSpace) - xSpace
        let heightMatrix    = columns*(heightCell + ySpace) - ySpace
        let xStart          = xCenter - widthMatrix / 2
        let yStart          = yCenter + heightMatrix / 2 - heightCell
        
        xForResult = xStart
        var yCurrent = yStart

        for col in 0 ..< columns {
            var xCurrent = xStart
            for row in 0 ..< rows {
                if row == rows - 1 {
                    let textField = NSTextField()
                    textField.frame = CGRect(x: xCurrent, y: yCurrent, width: widthCell, height: heightCell)
                    textField.bezelStyle = .roundedBezel
                    if fromFile {
                        textField.stringValue = String(matrixB[col])
                    } else {
                        textField.placeholderString = "b{\(col)}"
                    }
                    textField.alignment = .right
                    textField.textColor = .blue
                    textField.translatesAutoresizingMaskIntoConstraints = false
                    view.addSubview(textField)
                    arrayB.append(textField)
                } else {
                    let textField = NSTextField()
                    textField.frame = CGRect(x: xCurrent, y: yCurrent, width: widthCell, height: heightCell)
                    if fromFile {
                        textField.stringValue = String(matrixA[col][row])
                    } else {
                        textField.placeholderString = "a{\(col),\(row)}"
                    }
                    textField.alignment = .right
                    textField.translatesAutoresizingMaskIntoConstraints = false
                    view.addSubview(textField)
                    arrayA.append(textField)
                }
                xCurrent += widthCell + xSpace
            }
            yCurrent -= heightCell + ySpace
        }
    }
    
    private func fillSize() {
        size.removeAllItems()
        size.addItems(withTitles: matrixSize.keys.sorted())
    }
    
    private func setCurrentSize() {
        guard let selectedItem = size.selectedItem?.title else {
            return
        }
        currentSize = matrixSize[selectedItem]!
    }
    
    private func createResult() {
               
        result.forEach({$0.removeFromSuperview()})
        result = []
        
        var xRes = xForResult
        let y = 20
        
        for x in 0 ..< currentSize {
            let xn = NSTextField()
            xn.frame = CGRect(x: xRes, y: y, width: widthCell, height: heightCell)
            xn.placeholderString = "x{\(x+1)}"
            xn.alignment = .right
            xn.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(xn)
            result.append(xn)
            xRes += xSpace + widthCell
        }
        
    }

    // MARK: - Constants
    
    let xSpace = 20
    let ySpace = 30
    
    let widthCell = 50
    let heightCell = 21
    
    let xCenter = 654
    let yCenter = 326
    
}



