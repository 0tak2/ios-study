//
//  DatePickerContentView.swift
//  Today
//
//  Created by 임영택 on 12/18/24.
//

import UIKit

class DatePickerContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var date = Date.now
        
        func makeContentView() -> any UIView & UIContentView {
            DatePickerContentView(self)
        }
    }
    
    var datePicker = UIDatePicker()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(datePicker)
        datePicker.preferredDatePickerStyle = .inline // displays an editable calendar that isn’t hidden behind a button or menu
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        datePicker.date = configuration.date
    }
}

extension UICollectionViewListCell {
    func datePickerConfiguration() -> DatePickerContentView.Configuration {
        DatePickerContentView.Configuration()
    }
}
