//
//  AnnotationTypePickerAdapter.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 06.01.2023.
//

import UIKit

// MARK: - AnnotationType
enum AnnotationType: CaseIterable {
    case location
    case nature
    case building
    case note
    
    var title: String {
        switch self {
            case .location:
                return NSLocalizedString("annotation.location", comment: "")
            case .nature:
                return NSLocalizedString("annotation.nature", comment: "")
            case .building:
                return NSLocalizedString("annotation.building", comment: "")
            case .note:
                return NSLocalizedString("annotation.note", comment: "")
        }
    }
}

// MARK: - AnnotationTypePickerAdapterProtocol
protocol AnnotationTypePickerAdapterProtocol: UIPickerViewDelegate, UIPickerViewDataSource {
    
}

// MARK: - AnnotationTypePickerAdapter
final class AnnotationTypePickerAdapter: NSObject, AnnotationTypePickerAdapterProtocol {
    
    private var pickerView: UIPickerView?
    
    private let items = AnnotationType.allCases
    
    func configurate(pickerView: UIPickerView) {
        pickerView.delegate = self
        pickerView.dataSource = self
        self.pickerView = pickerView
    }
}

// MARK: - UIPickerViewDelegate
extension AnnotationTypePickerAdapter: UIPickerViewDelegate {
    
}

// MARK: - UIPickerViewDataSource
extension AnnotationTypePickerAdapter: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        items[row].title
    }
}
