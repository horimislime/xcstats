import Foundation

private extension String {
    func filled(upTo length: Int) -> String {
        guard length >= self.count + 2 else {
            return String(self)
        }
        
        let filledString = " " + String(self)
        return filledString + String(repeating: " ", count: length - filledString.count)
    }
}

private extension Statistics.PairValue {
    var description: String {
        return "\(title): \(value)"
    }
}

private extension Statistics {
    
    func contentWidth() -> Int {
        let titleWidth = title.count
        let valueWidth: Int = {
            switch value {
            case .single(let singleValue):
                return singleValue.count
            case .multi(let values):
                return values.compactMap({ $0.description.count }).max() ?? 0
            }
        }()
        return titleWidth + valueWidth
    }
}

final class TableOutputBuilder {
    
    private var source: [Statistics] = []
    
    func numberOfSections() -> Int {
        return source.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch source[section].value {
        case .single:
            return 1
        case .multi(let values):
            return values.count
        }
    }
    
    func title(inSection section: Int, row: Int) -> String {
        let columnWidth = titleColumnWidth()
        if row == 0 {
            let title = source[section].title
            return title.filled(upTo: columnWidth)
        }
        
        return String().filled(upTo: columnWidth)
    }
    
    func value(inSection section: Int, row: Int) -> String {
        let columnWidth = valueColumnWidth()
        switch source[section].value {
        case .single(let value):
            return value.filled(upTo: columnWidth)
        case .multi(let values):
            return values[row].description.filled(upTo: columnWidth)
        }
    }
    
    func titleColumnWidth() -> Int {
        let maxWidth: Int = source.compactMap({ $0.title.count }).max() ?? 0
        return maxWidth + 2
    }
    
    func valueColumnWidth() -> Int {
        let maxWidth: Int = source
            .compactMap({ s in
                switch s.value {
                case .single(let value):
                    return value.count
                case .multi(let values):
                    return values.compactMap({ $0.description.count }).max() ?? 0
                }
            })
            .max() ?? 0
        
        return maxWidth + 2
    }
    
    
    func append(_ statistics: Statistics) {
        source.append(statistics)
    }
    
    func header(titleWidth: Int, valueWidth: Int) -> String {
        return "┌\(String(repeating: "─", count: titleWidth))┬\(String(repeating: "─", count: valueWidth))┐"
    }
    
    func separator(titleWidth: Int, valueWidth: Int) -> String {
        return "├\(String(repeating: "─", count: titleWidth))┼\(String(repeating: "─", count: valueWidth))┤"
    }
    
    func footer(titleWidth: Int, valueWidth: Int) -> String {
        return "└\(String(repeating: "─", count: titleWidth))┴\(String(repeating: "─", count: valueWidth))┘"
    }
    
    func row(title: String, value: String) -> String {
        return "│\(title)│\(value)│"
    }
    
    func build() -> [String] {
        
        var result: [String] = []
        let titleWidth = titleColumnWidth()
        let valueWidth = valueColumnWidth()
        
        result.append(header(titleWidth: titleWidth, valueWidth: valueWidth))
        for s in 0..<numberOfSections() {
            for r in 0..<numberOfRows(in: s) {
                let row = self.row(title: title(inSection: s, row: r), value: value(inSection: s, row: r))
                result.append(row)
            }
            if s + 1 < numberOfSections() {
                let separator = self.separator(titleWidth: titleWidth, valueWidth: valueWidth)
                result.append(separator)
            }
        }
        let footer = self.footer(titleWidth: titleWidth, valueWidth: valueWidth)
        result.append(footer)
        
        return result
    }
}
