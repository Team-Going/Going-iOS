//
//  CreateTravelViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/4/24.
//

import UIKit

import SnapKit

final class CreateTravelViewController: UIViewController {
    
    // MARK: - Properties
    
    private weak var activeLabel: UILabel?
    
    private var createTravelData = CreateTravelRequestAppData(travelTitle: "", startDate: "", endDate: "", a: 0, b: 0, c: 0, d: 0, e: 0)
    
    private var isTravelNameTextFieldGood: Bool = false

    // MARK: - UI Properties
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonWithTitle("새로운 여행 만들기"))
    private let navigationUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let travelNameLabel = DOOLabel(font: .pretendard(.body2_bold),
                                           color: .gray700,
                                           text: StringLiterals.CreateTravel.nameTitle)
    private let travelDateLabel = DOOLabel(font: .pretendard(.body2_bold),
                                           color: .gray700,
                                           text: StringLiterals.CreateTravel.dateTitle)
    
    private var travelNameTextFieldCount: Int = 0

    private lazy var travelNameTextField: UITextField = {
        let field = UITextField()
        field.setLeftPadding(amount: 12)
        field.font = .pretendard(.body3_medi)
        field.setTextField(forPlaceholder: StringLiterals.CreateTravel.namePlaceHolder, forBorderColor: .gray200)
        field.setPlaceholderColor(.gray200)
        field.layer.cornerRadius = 6
        field.textColor = .gray700
        field.addTarget(self, action: #selector(travelNameTextFieldDidChange), for: .editingChanged)
        return field
    }()
    
    private let characterCountLabel = DOOLabel(font: .pretendard(.detail2_regular),
                                               color: .gray200,
                                               text: "0/15")
    
    private let warningLabel: DOOLabel = {
        let label = DOOLabel(font: .pretendard(.body3_medi), color: .red400)
        label.isHidden = true
        return label
    }()
    
    private let dateHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 6
        return stack
    }()
    
    private let startDateLabel: DOOLabel = {
        let label = DOOLabel(font: .pretendard(.body3_medi), color: .gray200, text: "시작일", padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0))
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.gray200.cgColor
        return label
    }()
    
    private let endDateLabel: DOOLabel = {
        let label = DOOLabel(font: .pretendard(.body3_medi), color: .gray200, text: "종료일", padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0))
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.gray200.cgColor
        return label
    }()
    
    private let dashLabel = DOOLabel(font: .pretendard(.detail2_regular), color: .gray700, text: "-")
    
    private lazy var createTravelButton: DOOButton = {
        let btn = DOOButton(type: .unabled, title: "다음")
        btn.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private let bottomSheetVC = DatePickerBottomSheetViewController()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
        setGestureRecognizer()
        setDelegate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotifications()
    }
}

// MARK: - Private Extension

private extension CreateTravelViewController {
    
    func setStyle() {
        self.view.backgroundColor = .white000
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         navigationUnderlineView,
                         travelNameLabel,
                         travelDateLabel,
                         travelNameTextField,
                         warningLabel,
                         characterCountLabel,
                         dateHorizontalStackView,
                         createTravelButton)
        
        dateHorizontalStackView.addArrangedSubviews(startDateLabel, dashLabel, endDateLabel)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        navigationUnderlineView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        travelNameLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        
        travelNameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(travelNameLabel.snp.bottom).offset(8)
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.height.equalTo(ScreenUtils.getHeight(48))
        }
        
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(travelNameTextField.snp.bottom).offset(4)
            $0.leading.equalTo(travelNameTextField.snp.leading).offset(4)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(travelNameTextField.snp.bottom).offset(4)
            $0.trailing.equalTo(travelNameTextField.snp.trailing).offset(-4)
        }
        
        travelDateLabel.snp.makeConstraints {
            $0.top.equalTo(travelNameTextField.snp.bottom).offset(38)
            $0.leading.equalToSuperview().inset(24)
        }
        
        dateHorizontalStackView.snp.makeConstraints {
            $0.top.equalTo(travelDateLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        startDateLabel.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(48))
            $0.width.equalTo(ScreenUtils.getWidth(154))
        }
        
        endDateLabel.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(48))
            $0.width.equalTo(ScreenUtils.getWidth(154))
        }
        
        createTravelButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setGestureRecognizer() {
        let startDateTapGesture = UITapGestureRecognizer(target: self, action: #selector(startDateLabelTapped))
        startDateLabel.isUserInteractionEnabled = true
        startDateLabel.addGestureRecognizer(startDateTapGesture)
        
        let endDateTapGesture = UITapGestureRecognizer(target: self, action: #selector(endDateLabelTapped))
        endDateLabel.isUserInteractionEnabled = true
        endDateLabel.addGestureRecognizer(endDateTapGesture)
    }
    
    func setDelegate() {
        bottomSheetVC.delegate = self
        travelNameTextField.delegate = self
    }
    
    /// 텍스트 필드에 들어갈 텍스트를 DateFormatter로  변환하는 메서드
    func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        return formatter.string(from: date)
    }
    
    /// DatePicker Present 하는 메서드
    func showDatePicker(for label: UILabel) {
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Validation Methods
    
    func updateCreateButtonState() {
        let isTravelNameTextFieldEmpty = travelNameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty
        
        let isStartDateSet = startDateLabel.text != "시작일"
        let isEndDateSet = endDateLabel.text != "종료일"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        var isDateValid = true
        var isEndDateNotPast = true
        
        if let startDateText = startDateLabel.text?.trimmingCharacters(in: .whitespaces),
           let endDateText = endDateLabel.text?.trimmingCharacters(in: .whitespaces),
           let startDate = dateFormatter.date(from: startDateText),
           let endDate = dateFormatter.date(from: endDateText) {
            isDateValid = startDate <= endDate
            let calendar = Calendar.current
            let today = Date()
            if let deletedToday = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: today) {
                isEndDateNotPast = endDate >= deletedToday
            }
        }
        
        createTravelButton.currentType = (!isTravelNameTextFieldEmpty
                                          && isStartDateSet
                                          && isEndDateSet
                                          && isTravelNameTextFieldGood
                                          && isDateValid
                                          && isEndDateNotPast) ? .enabled : .unabled
    }
    
    func travelNameTextFieldCheck() {
        guard let text = travelNameTextField.text else { return }
        characterCountLabel.text = "\(text.count) / 15"
        
        if text.count >  15 {
            travelNameTextField.textColor = .red500
            warningLabel.isHidden = false
            warningLabel.text = "이름은 15자 이하여야 합니다"
            isTravelNameTextFieldGood = false
        } else if text.count == 0 {
            travelNameTextField.layer.borderColor =
            UIColor.gray200.cgColor
            characterCountLabel.textColor = .gray200
            warningLabel.isHidden = true
            isTravelNameTextFieldGood = false
        } else if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.isTravelNameTextFieldGood = false
            travelNameTextField.layer.borderColor = UIColor.red500.cgColor
            characterCountLabel.textColor = .red500
            warningLabel.isHidden = false
            warningLabel.text = "이름에는 공백만 입력할 수 없어요."
        } else {
            self.isTravelNameTextFieldGood = true
            travelNameTextField.layer.borderColor = UIColor.gray700.cgColor
            characterCountLabel.textColor = .gray400
            travelNameTextField.textColor = .gray400
            warningLabel.isHidden = true
        }
        updateCreateButtonState()
    }
    
    // MARK: - @objc Methods
    
    @objc
    func startDateLabelTapped() {
        activeLabel = startDateLabel
        showDatePicker(for: startDateLabel)
    }
    
    @objc
    func endDateLabelTapped() {
        activeLabel = endDateLabel
        showDatePicker(for: endDateLabel)
    }
    
    /// 키보드에 따라 버튼 위로 움직이게 하는 메서드
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let safeAreaBottomInset = view.safeAreaInsets.bottom
            
            UIView.animate(withDuration: 0.3) {
                self.createTravelButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + safeAreaBottomInset)
            }
        }
    }
    
    /// 키보드에 따라 버튼 원래대로 움직이게 하는 메서드
    @objc
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.createTravelButton.transform = .identity
        }
    }
    
    @objc
    func createButtonTapped() {
        toDTO()
        
        let nextVC = TravelTestViewController()
        nextVC.createRequestData = createTravelData
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc
    func travelNameTextFieldDidChange() {
        travelNameTextFieldCheck()
    }
}

extension CreateTravelViewController: BottomSheetDelegate {
    func datePickerDidChanged(date: Date) {
        let formattedDate = dateFormat(date: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        if activeLabel == startDateLabel {
            startDateLabel.text = formattedDate
            // endDate가 설정되어 있고 startDate가 endDate보다 뒤에 있는지 확인
            if let endDateText = endDateLabel.text,
               let endDate = dateFormatter.date(from: endDateText),
               date > endDate {
                DOOToast.show(message: "여행 종료일보다 여행 시작일이 빨라요!", insetFromBottom: ScreenUtils.getHeight(374))
            }
        } else if activeLabel == endDateLabel {
            endDateLabel.text = formattedDate
            // startDate가 설정되어 있고 endDate가 startDate보다 앞에 있는지 확인
            if let startDateText = startDateLabel.text,
               let startDate = dateFormatter.date(from: startDateText),
               date < startDate {
                DOOToast.show(message: "여행 종료일보다 여행 시작일이 빨라요!", insetFromBottom: ScreenUtils.getHeight(374))
            }
        }
    }
    
    func didSelectDate(date: Date) {
        let formattedDate = dateFormat(date: date)
        activeLabel?.text = formattedDate
        activeLabel?.textColor = .gray700
        activeLabel?.layer.borderColor = UIColor.gray700.cgColor
        activeLabel = nil
        
        updateCreateButtonState()
    }
}

extension CreateTravelViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        travelNameTextFieldCheck()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        travelNameTextFieldCheck()
        if let text = textField.text, text.isEmpty {
            textField.layer.borderColor = UIColor.gray200.cgColor
        }
    }
    
    /// 엔터키 누르면 키보드 내리는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateTravelViewController {
    func toDTO() {
        guard let name = travelNameTextField.text else { return }
        guard let startDate = startDateLabel.text else { return }
        guard let endDate = endDateLabel.text else { return }
        createTravelData.travelTitle = name
        createTravelData.startDate = startDate
        createTravelData.endDate = endDate
    }
}
