//
//  CreateTravelViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/4/24.
//

import UIKit

import SnapKit

final class CreateTravelViewController: UIViewController {
    
    // MARK: - Size
        
    private let absoluteHeight = UIScreen.main.bounds.height
    private let absoluteWidth = UIScreen.main.bounds.width
    
    // MARK: - Properties
    
    private weak var activeLabel: UILabel?
    
    // MARK: - UI Properties
    
    private let navigationBar: NavigationBarView = {
        let nav = NavigationBarView()
        nav.titleLabel.text = "여행 생성하기"
        return nav
    }()
    
    private let travelNameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2_bold)
        label.text = "여행 이름"
        label.textColor = .gray700
        return label
    }()
    
    private let travelDateLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2_bold)
        label.text = "여행 날짜"
        label.textColor = .gray700
        return label
    }()
    
    private let travelNameTextField: UITextField = {
        let field = UITextField()
        field.setLeftPadding(amount: 12)
        field.font = .pretendard(.body3_medi)
        field.setTextField(forPlaceholder: "여행 이름을 입력해주세요.", forBorderColor: .gray200)
        field.roundCorners(cornerRadius: 6,
                                         maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        return field
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/15"
        label.font = .pretendard(.detail2_regular)
        label.textColor = .gray200
        return label
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "여행 이름을 입력해주세요."
        label.font = .pretendard(.body3_medi)
        label.textColor = .red400
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
    
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()
    
    private let dashLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.detail2_regular)
        label.text = "-"
        label.textColor = .gray700
        label.textAlignment = .center
        return label
    }()
    
    private let createTravelButton = DOOButton(type: .unabled, title: "생성하기")
    
    private let bottomSheetVC = BottomSheetViewController()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierachy()
        setLayout()
        setGestureRecognizer()
        setProperty()
        setAddTarget()
        setDelegate()
        setNotification()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
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
            // 키보드 높이
            let keyboardHeight = keyboardFrame.height
            
            // Bottom Safe Area 높이
            let safeAreaBottomInset = view.safeAreaInsets.bottom
            
            // createTravelButton을 키보드 높이만큼 위로 이동하는 애니메이션 설정
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
    
    /// 뷰 탭 시 키보드 내리는 메서드
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// 여행 이름 텍스트 필드 채우지 않고 넘어갔을 때 경고 보여주는 메서드
    @objc
    func outsideTapped(_ sender: UITapGestureRecognizer) {
        if travelNameTextField.text?.isEmpty ?? true {
            // travelNameTextField가 비어 있다면
            travelNameTextField.layer.borderColor = UIColor.red500.cgColor
            characterCountLabel.textColor = .red500
            warningLabel.isHidden = false
        } else {
            // travelNameTextField에 텍스트가 있으면
            travelNameTextField.layer.borderColor = UIColor.gray700.cgColor
            warningLabel.isHidden = true
        }
    }
    
    @objc
    func createButtonTapped() {
        let vc = CreatingSuccessViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Private Extension

private extension CreateTravelViewController {
    
    func setStyle() {
        self.view.backgroundColor = .white000
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierachy() {
        view.addSubviews(navigationBar,
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
            $0.height.equalTo(absoluteHeight / 812 * 50)
        }
        
        travelNameLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        
        travelNameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(travelNameLabel.snp.bottom).offset(8)
            $0.width.equalTo(absoluteWidth / 375 * 327)
            $0.height.equalTo(absoluteHeight / 812 * 48)
        }
        
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(travelNameTextField.snp.bottom).offset(4)
            $0.leading.equalTo(travelNameTextField.snp.leading).offset(4)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(travelNameTextField.snp.bottom).offset(4)
            $0.trailing.equalTo(travelNameTextField.snp.trailing).offset(4)
        }
        
        travelDateLabel.snp.makeConstraints {
            $0.top.equalTo(travelNameTextField.snp.bottom).offset(38)
            $0.leading.equalToSuperview().inset(24)
        }
        
        dateHorizontalStackView.snp.makeConstraints {
            $0.top.equalTo(travelDateLabel.snp.bottom).offset(8)
            $0.height.equalTo(46)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        startDateLabel.snp.makeConstraints {
            $0.height.equalTo(absoluteHeight / 812 * 48)
            $0.width.equalTo(absoluteWidth / 375 * 154)
        }
        
        endDateLabel.snp.makeConstraints {
            $0.height.equalTo(absoluteHeight / 812 * 48)
            $0.width.equalTo(absoluteWidth / 375 * 154)
        }
        
        createTravelButton.snp.makeConstraints {
            $0.height.equalTo(absoluteHeight / 812 * 50)
            $0.width.equalTo(absoluteWidth / 375 * 327)
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(outsideTapped(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setProperty() {
        [startDateLabel, endDateLabel].forEach { label in
            label.text = "   " + (label == startDateLabel ? "시작일" : "종료일")
            label.font = .pretendard(.body3_medi)
            label.textColor = .gray200
            label.layer.borderColor = UIColor.gray200.cgColor
            label.layer.borderWidth = 1
            label.roundCorners(cornerRadius: 6, 
                               maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        }
    }
    
    func setAddTarget() {
        createTravelButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
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
    
    /// DatePicker Presnet 하는 메서드
    func showDatePicker(for label: UILabel) {
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateTravelViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Validation Methods
    
    func updateCreateButtonState() {
        let isTravelNameEntered = !(travelNameTextField.text?.isEmpty ?? true)
        
        // TODO: - Label에 Padding 주는 형식으로 변경
        
        let isStartDateSet = startDateLabel.text != "   시작일"
        let isEndDateSet = endDateLabel.text != "   종료일"
        
        createTravelButton.currentType = (isTravelNameEntered && isStartDateSet && isEndDateSet) ? .enabled : .unabled
    }
}

extension CreateTravelViewController: BottomSheetDelegate {
    func didSelectDate(date: Date) {
        let formattedDate = "   " + dateFormat(date: date)
        activeLabel?.text = formattedDate
        activeLabel?.textColor = .gray700
        activeLabel?.layer.borderColor = UIColor.gray700.cgColor
        activeLabel = nil
        
        updateCreateButtonState()
    }
}

extension CreateTravelViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == travelNameTextField {
            /// 현재 텍스트 필드의 텍스트와 입력된 문자를 합쳐서 길이를 계산
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let maxLength = 15
            
            if newText.count > maxLength {
                textField.layer.borderColor = UIColor.red400.cgColor
            } else if newText.count >= 1 {
                textField.layer.borderColor = UIColor.gray700.cgColor
                warningLabel.isHidden = true
                characterCountLabel.textColor = .gray400
            } else {
                textField.layer.borderColor = UIColor.gray200.cgColor
            }
            
            characterCountLabel.text = "\(newText.count)/\(maxLength)"
            
            // 최대 길이를 초과하면 입력을 막음
            return newText.count < maxLength
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == travelNameTextField {
            updateCreateButtonState()
        }
    }
}
