//
//  PaymentViewController.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController {
    private let viewModel: PaymentViewModel!
    
    private var customPickerViews = [UIPickerView]()
    private var currencyPicker = UIPickerView()
    private var customDatePickerViews = [UIDatePicker]()
    
    private var cardNumberTxt: CustomTextField!
    private var cardExpMonthTxt: CustomTextField!
    private var cardExpYearTxt: CustomTextField!
    private var cardCvvTxt: CustomTextField!
    private var amountTxt: CustomTextField!
    private var currencyTxt: CustomTextField!
    
    private var confirmButton: UIButton!
    private var mainStackView: UIStackView!
    
    private var isSelectType = false
    private var textFields = [CustomTextField]()
    private var selectTextFields = [CustomTextField]()
    private var selectDateFields = [CustomTextField]()
    
    private let currencyList = ["AZN", "USD", "EUR"]
    
    init(with model: PaymentViewModel) {
        self.viewModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Setup Views
extension PaymentViewController {
    private func setup() {
        setupNavigationController()
        setupView()
        
        setupCurrencyPicker()
    }
    
    private func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Payment"
    }
    
    
    private func setupView() {
        let textFieldHeight: CGFloat = 45
        mainStackView = createStackView(for: nil, in: .vertical, spacing: 45)
        
        let scrollView: UIScrollView = {
            let sv = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.backgroundColor = .clear
            sv.contentSize = CGSize(width: view.bounds.width, height: 1500)
            sv.showsVerticalScrollIndicator = false
            sv.showsHorizontalScrollIndicator = false
            sv.isScrollEnabled = true
            return sv
        }()
        
        view.addSubview(scrollView)
        
        let contentView: UIView = {
            let vw = UIView()
            vw.translatesAutoresizingMaskIntoConstraints = false
            return vw
        }()
        scrollView.addSubview(contentView)
        contentView.addSubview(mainStackView)
        
        if let fields = viewModel.fields {
            var textField: CustomTextField!
            for field in fields {
                textField = createTextField(from: field)
                mainStackView.addArrangedSubview(textField)
                textField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
            }
        } else {
            errorAlert(with: "No Data Found")
        }
        
        cardNumberTxt = {
            let textField = CustomTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.label = "Card Number"
            textField.keyboardType = .numberPad
            return textField
        }()
        contentView.addSubview(cardNumberTxt)
        
        cardExpYearTxt = {
            let textField = CustomTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.label = "Card Exp Year"
            textField.keyboardType = .numberPad
            textField.delegate = self
            return textField
        }()
        
        cardExpMonthTxt = {
            let textField = CustomTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.label = "Card Exp Month"
            textField.keyboardType = .numberPad
            textField.delegate = self
            return textField
        }()
        let cardExpStack = createStackView(for: [cardExpMonthTxt, cardExpYearTxt], in: .horizontal, spacing: 10)
        contentView.addSubview(cardExpStack)
        
        cardCvvTxt = {
            let textField = CustomTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.label = "Card Cvv"
            textField.keyboardType = .numberPad
            return textField
        }()
        contentView.addSubview(cardCvvTxt)
        
        amountTxt = {
            let textField = CustomTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.label = "Amount"
            textField.keyboardType = .decimalPad
            return textField
        }()
        contentView.addSubview(amountTxt)
        
        currencyTxt = {
            let textField = CustomTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.label = "Currency"
            return textField
        }()
        contentView.addSubview(currencyTxt)
        
        confirmButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Confirm", for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 3
            button.addTarget(self, action: #selector(confirmed), for: .touchUpInside)
            return button
        }()
        contentView.addSubview(confirmButton)
        
        // setup constraints
        let safeArea = view.safeAreaLayoutGuide
        
        scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        cardNumberTxt.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 35).isActive = true
        cardNumberTxt.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
        cardNumberTxt.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        cardNumberTxt.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        cardExpStack.topAnchor.constraint(equalTo: cardNumberTxt.bottomAnchor, constant: 35).isActive = true
        cardExpStack.leadingAnchor.constraint(equalTo: cardNumberTxt.leadingAnchor).isActive = true
        cardExpStack.trailingAnchor.constraint(equalTo: cardNumberTxt.trailingAnchor).isActive = true
        
        cardExpMonthTxt.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        cardExpYearTxt.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        cardCvvTxt.topAnchor.constraint(equalTo: cardExpStack.bottomAnchor, constant: 35).isActive = true
        cardCvvTxt.leadingAnchor.constraint(equalTo: cardExpStack.leadingAnchor).isActive = true
        cardCvvTxt.trailingAnchor.constraint(equalTo: cardExpStack.trailingAnchor).isActive = true
        cardCvvTxt.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        amountTxt.topAnchor.constraint(equalTo: cardCvvTxt.bottomAnchor, constant: 35).isActive = true
        amountTxt.leadingAnchor.constraint(equalTo: cardCvvTxt.leadingAnchor).isActive = true
        amountTxt.trailingAnchor.constraint(equalTo: cardCvvTxt.trailingAnchor).isActive = true
        amountTxt.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        currencyTxt.topAnchor.constraint(equalTo: amountTxt.bottomAnchor, constant: 35).isActive = true
        currencyTxt.leadingAnchor.constraint(equalTo: amountTxt.leadingAnchor).isActive = true
        currencyTxt.trailingAnchor.constraint(equalTo: amountTxt.trailingAnchor).isActive = true
        currencyTxt.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        confirmButton.topAnchor.constraint(equalTo: currencyTxt.bottomAnchor, constant: 35).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: currencyTxt.leadingAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: currencyTxt.trailingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    private func createTextField(from data: Field) -> CustomTextField {
        switch data.type {
        case .selectBox:
            let selectTypeTextField: CustomTextField = {
                let textField = CustomTextField()
                textField.label = data.label
                textField.tag = Int(data.id ?? "0") ?? 0
                return textField
            }()
            
            let customPickerView = UIPickerView()
            customPickerView.tag = Int(data.id ?? "0") ?? 0
            
            selectTextFields.append(selectTypeTextField)
            customPickerViews.append(customPickerView)
            setupPickerView(for: customPickerView, textField: selectTypeTextField, barButton: UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(doneAction)))
            
            return selectTypeTextField
        case .date:
            let dateTextField: CustomTextField = {
                let textField = CustomTextField()
                textField.label = data.label
                textField.tag = Int(data.id ?? "0") ?? 0
                return textField
            }()
            
            let customDatePicker = UIDatePicker()
            customDatePicker.tag = Int(data.id ?? "0") ?? 0
            
            selectDateFields.append(dateTextField)
            customDatePickerViews.append(customDatePicker)
            setupPickerView(forDatePicker: customDatePicker, textField: dateTextField, barButton: UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(doneForDate)))
            
            return dateTextField
        default:
            let customTextField: CustomTextField = {
                let textField = CustomTextField()
                textField.label = data.label
                textField.tag = Int(data.id ?? "0") ?? 0
                textField.keyboardType = keyboardType(type: data.type ?? .textField)
                return textField
            }()
            textFields.append(customTextField)
            return customTextField
        }
    }
}


//MARK: Class Methods
extension PaymentViewController {
    @objc private func confirmed() {
        if validation() {
            viewModel.paymentRequest.providerId = viewModel.selectedProvider?.id
            viewModel.paymentRequest.fields = viewModel.selectedFields
            
            viewModel.paymentRequest.amount = Amount()
            viewModel.paymentRequest.amount?.value = amountTxt.text
            viewModel.paymentRequest.amount?.currency = currencyTxt.text
            
            viewModel.paymentRequest.card = Card()
            viewModel.paymentRequest.card?.number = cardNumberTxt.text
            viewModel.paymentRequest.card?.expMonth = cardExpMonthTxt.text
            viewModel.paymentRequest.card?.expYear = cardExpYearTxt.text
            viewModel.paymentRequest.card?.cvv = cardCvvTxt.text
            
            onMakePayment()
        } else {
            errorAlert(with: "Please fill the fields")
        }
    }
    
    private func keyboardType(type: FieldType) -> UIKeyboardType {
        switch type {
        case .numeric:
            return .numberPad
        case .float:
            return .decimalPad
        default:
            return .default
        }
    }
    
    private func validation() -> Bool {
        for selectField in selectTextFields {
            if viewModel.isSelectedEmpty(tag: String(selectField.tag)) {
                return false
            }
        }
        
        for dateField in selectDateFields {
            if viewModel.isSelectedEmpty(tag: String(dateField.tag)) {
                return false
            }
        }
        
        for txtField in textFields {
            if let text = txtField.text, !text.isEmpty {
                viewModel.addToSelectedField(id: String(txtField.tag), row: 0, value: text)
            } else {
                return false
            }
        }
        
        guard let cNumber = cardNumberTxt.text, !cNumber.isEmpty else { return false }
        guard let cExpMonth = cardExpMonthTxt.text, !cExpMonth.isEmpty else { return false }
        guard let cExpYear = cardExpYearTxt.text, !cExpYear.isEmpty else { return false }
        guard let cCvv = cardCvvTxt.text, !cCvv.isEmpty else { return false }
        guard let cAmount = amountTxt.text, !cAmount.isEmpty else { return false }
        guard let cCurrency = currencyTxt.text, !cCurrency.isEmpty else { return false }
        
        return true
    }
    
    private func onMakePayment() {
        activityIndicator.startAnimating()
        viewModel.makePayment { [weak self] error in
            self?.activityIndicator.stopAnimating()
            
            if let err = error {
                self?.errorAlert(with: ErrorService.handle(error: err))
                return
            }
            
            DispatchQueue.main.async {
                self?.onReceiptView()
            }
        }
    }
    
    private func onReceiptView() {
        let controller = UINavigationController(rootViewController: ReceiptViewController(with: viewModel.receipt ?? Receipt()))
        controller.modalPresentationStyle = .fullScreen
        
        present(controller, animated: true)
    }
}

//MARK: PickerViews
extension PaymentViewController {
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == currencyPicker {
            return currencyList.count
        }
        
        return viewModel.getCountByTag(tag: String(pickerView.tag))
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == currencyPicker {
            return currencyList[row]
        }
        
        return viewModel.getValueByTag(tag: String(pickerView.tag), row: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == currencyPicker {
            populateCurrencyData(selectedRow: row)
        }
        
        viewModel.addToSelectedField(id: String(pickerView.tag), row: row)
    }
    
    private func populateCurrencyData(selectedRow row: Int) {
        currencyTxt.text = self.pickerView(currencyPicker, titleForRow: row, forComponent: 0) ?? ""
        viewModel.paymentRequest.amount?.currency = currencyList[row]
    }
    
    @objc private func doneActionCurrency() {
        if let textField = currencyTxt {
            textField.resignFirstResponder()
            populateCurrencyData(selectedRow: currencyPicker.selectedRow(inComponent: 0))
        }
    }
    
    @objc private func doneAction() {
        for i in 0..<selectTextFields.count {
            let row = customPickerViews[i].selectedRow(inComponent: 0)
            selectTextFields[i].text = self.pickerView(customPickerViews[i], titleForRow: row, forComponent: 0) ?? ""
            self.pickerView(customPickerViews[i], didSelectRow: row, inComponent: 0)
            selectTextFields[i].resignFirstResponder()
        }
    }
    
    @objc private func doneForDate() {
        for i in 0..<selectDateFields.count {
            let dateTxt = customDatePickerViews[i].date.toString()
            selectDateFields[i].text = customDatePickerViews[i].date.toString()
            viewModel.addToSelectedField(id: String(customDatePickerViews[i].tag), row: 0, value: dateTxt)
            selectDateFields[i].resignFirstResponder()
        }
    }
    
    fileprivate func setupCurrencyPicker() {
        if let textField = currencyTxt {
            setupPickerView(for: currencyPicker, textField: textField, barButton: UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(doneActionCurrency)))
        }
    }
}

//MARK: Textfield Delegate Methods
extension PaymentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cardExpYearTxt || textField == cardExpMonthTxt {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let count = textFieldText.count - textFieldText[rangeOfTextToReplace].count + string.count
            return count <= 2
        }
        return true
    }
}
