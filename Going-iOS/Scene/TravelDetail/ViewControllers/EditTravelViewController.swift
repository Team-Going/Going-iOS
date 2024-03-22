//
//  EditTravelViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/2/24.
//

import UIKit

import SnapKit

final class EditTravelViewController: UIViewController {
    
    // MARK: - Properties
    
    var tripId: Int = 0
    
    var travelData: TravelDetailResponseStruct? {
        didSet {
            self.travelNameView.travelNameTextField.text = travelData?.title
            self.travelDateView.startDateLabel.text = travelData?.startDate
            self.travelDateView.endDateLabel.text = travelData?.endDate
            self.travelNameView.characterCountLabel.text = "\(travelData?.title.count ?? 0)" + "/15"
        }
    }
    
    var currentTravelData = TravelDetailResponseStruct(tripID: 0, title: "", startDate: "", endDate: "")

    private var patchRequestBody: EditTravelRequestStruct = .init(title: "", startDate: "", endDate: "")

    private weak var activeLabel: UILabel?
    
    private var isTravelNameTextFieldGood: Bool = false
    
    // MARK: - UI Properites
    
    private lazy var keyboardLayoutGuide = view.keyboardLayoutGuide

    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonWithTitle("여행 정보 수정"))
    
    private let navigationUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .gray100)
        return view
    }()
    
    private lazy var travelNameView: TravelNameView = {
        let view = TravelNameView()
        view.travelNameTextField.addTarget(self, action: #selector(travelNameTextFieldDidChange), for: .editingChanged)
        return view
    }()
    
    private let travelDateView = TravelDateView()

    private lazy var saveButton: DOOButton = {
        let btn = DOOButton(type: .unabled, title: "저장하기")
        btn.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
        getAllTravelData(tripId: tripId)
        setColor()
    }
}

// MARK: - Private Methods

private extension EditTravelViewController {
    func setStyle() {
        self.view.backgroundColor = UIColor(resource: .white000)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         navigationUnderlineView,
                         travelNameView,
                         travelDateView,
                         saveButton)
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
        
        travelNameView.snp.makeConstraints {
            $0.top.equalTo(navigationUnderlineView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(101))
        }
        
        travelDateView.snp.makeConstraints {
            $0.top.equalTo(travelNameView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(79))
        }
        
        saveButton.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-6)
        }
    }
    
    func setGestureRecognizer() {
        let startDateTapGesture = UITapGestureRecognizer(target: self, action: #selector(startDateLabelTapped))
        travelDateView.startDateLabel.isUserInteractionEnabled = true
        travelDateView.startDateLabel.addGestureRecognizer(startDateTapGesture)
        
        let endDateTapGesture = UITapGestureRecognizer(target: self, action: #selector(endDateLabelTapped))
        travelDateView.endDateLabel.isUserInteractionEnabled = true
        travelDateView.endDateLabel.addGestureRecognizer(endDateTapGesture)
    }
    
    func setDelegate() {
        bottomSheetVC.delegate = self
        travelNameView.travelNameTextField.delegate = self
    }
    
    /// 텍스트 필드에 들어갈 텍스트를 DateFormatter로  변환하는 메서드
    func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        return formatter.string(from: date)
    }
    
    /// DatePicker Present 하는 메서드
    func showDatePicker(for label: UILabel) {
        /// 사용자가 지정한 날짜에서부터 DatePicker 시작되도록 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        guard let stringDate = activeLabel?.text else { return }
        let savedDate = dateFormatter.date(from: stringDate)
        bottomSheetVC.datePickerView.date = savedDate ?? Date()
        
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    func setColor() {
        self.travelNameView.travelNameTextField.layer.borderColor = UIColor(resource: .gray700).cgColor
        self.travelNameView.characterCountLabel.textColor = UIColor(resource: .gray700)
        
        self.travelDateView.endDateLabel.textColor = UIColor(resource: .gray700)
        self.travelDateView.endDateLabel.layer.borderColor = UIColor(resource: .gray700).cgColor
        
        self.travelDateView.startDateLabel.textColor = UIColor(resource: .gray700)
        self.travelDateView.startDateLabel.layer.borderColor = UIColor(resource: .gray700).cgColor
    }
    
    // MARK: - Validation Methods
    
    func updateCreateButtonState() {
        let isTravelNameTextFieldEmpty = travelNameView.travelNameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        var isDateValid = true
        var isEndDateNotPast = true
        
        guard let initialData = travelData else { return }
        let currentData = currentTravelData
        let isChanged = initialData.title != currentData.title || 
                        initialData.startDate != currentData.startDate ||
                        initialData.endDate != currentData.endDate
        
        if let startDateText = travelDateView.startDateLabel.text?.trimmingCharacters(in: .whitespaces),
           let endDateText = travelDateView.endDateLabel.text?.trimmingCharacters(in: .whitespaces),
           let startDate = dateFormatter.date(from: startDateText),
           let endDate = dateFormatter.date(from: endDateText) {
            isDateValid = startDate <= endDate
            let calendar = Calendar.current
            let today = Date()
            if let deletedToday = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: today) {
                isEndDateNotPast = endDate >= deletedToday
            }
        }
        
        saveButton.currentType = (!isTravelNameTextFieldEmpty
                                          && isTravelNameTextFieldGood
                                          && isDateValid
                                          && isEndDateNotPast 
                                          && isChanged) ? .enabled : .unabled
    }
    
    func travelNameTextFieldCheck() {
        guard let text = travelNameView.travelNameTextField.text else { return }
        travelNameView.characterCountLabel.text = "\(text.count) / 15"
        currentTravelData.title = text
        
        updateCreateButtonState()
        
        if text.count >  15 {
            travelNameView.warningLabel.isHidden = false
            travelNameView.warningLabel.text = "이름은 15자 이하여야 해요"
            travelNameView.travelNameTextField.layer.borderColor = UIColor(resource: .red500).cgColor
            travelNameView.characterCountLabel.textColor = UIColor(resource: .red500)
            isTravelNameTextFieldGood = false
        } else if text.count == 0 {
            travelNameView.travelNameTextField.layer.borderColor =
            UIColor(resource: .gray200).cgColor
            travelNameView.characterCountLabel.textColor = UIColor(resource: .gray200)
            travelNameView.warningLabel.isHidden = true
            isTravelNameTextFieldGood = false
        } else if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.isTravelNameTextFieldGood = false
            travelNameView.travelNameTextField.layer.borderColor = UIColor(resource: .red500).cgColor
            travelNameView.characterCountLabel.textColor = UIColor(resource: .red500)
            travelNameView.warningLabel.isHidden = false
            travelNameView.warningLabel.text = "이름에는 공백만 입력할 수 없어요."
        } else {
            self.isTravelNameTextFieldGood = true
            travelNameView.travelNameTextField.layer.borderColor = UIColor(resource: .gray700).cgColor
            travelNameView.characterCountLabel.textColor = UIColor(resource: .gray400)
            travelNameView.travelNameTextField.textColor = UIColor(resource: .gray400)
            travelNameView.warningLabel.isHidden = true
        }
    }
    
    // MARK: - @objc Methods
    
    @objc
    func startDateLabelTapped() {
        activeLabel = travelDateView.startDateLabel
        showDatePicker(for: travelDateView.startDateLabel)
    }
    
    @objc
    func endDateLabelTapped() {
        activeLabel = travelDateView.endDateLabel
        showDatePicker(for: travelDateView.endDateLabel)
    }
    
    @objc
    func travelNameTextFieldDidChange() {
        travelNameTextFieldCheck()
    }
    
    @objc
    func saveButtonTapped() {
        HapticService.impact(.medium).run()
        
        let title = travelNameView.travelNameTextField.text ?? ""
        let startDate = travelDateView.startDateLabel.text ?? ""
        let endDate = travelDateView.endDateLabel.text ?? ""
        
        self.patchRequestBody = EditTravelRequestStruct(title: title, startDate: startDate, endDate: endDate)
        patchTravelData()
    }
}

extension EditTravelViewController: UITextFieldDelegate {
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
            textField.layer.borderColor = UIColor(resource: .gray200).cgColor
        }
    }
    
    /// 엔터키 누르면 키보드 내리는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditTravelViewController: BottomSheetDelegate {
    func datePickerDidChanged(date: Date) {
        let formattedDate = dateFormat(date: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        if activeLabel == travelDateView.startDateLabel {
            currentTravelData.startDate = formattedDate
            travelDateView.startDateLabel.text = formattedDate
            // endDate가 설정되어 있고 startDate가 endDate보다 뒤에 있는지 확인
            if let endDateText = travelDateView.endDateLabel.text,
               let endDate = dateFormatter.date(from: endDateText),
               date > endDate {
                DOOToast.show(message: "여행 종료일보다 여행 시작일이 빨라요!", insetFromBottom: ScreenUtils.getHeight(374))
            }
        } else if activeLabel == travelDateView.endDateLabel {
            currentTravelData.endDate = formattedDate
            travelDateView.endDateLabel.text = formattedDate
            // startDate가 설정되어 있고 endDate가 startDate보다 앞에 있는지 확인
            if let startDateText = travelDateView.startDateLabel.text,
               let startDate = dateFormatter.date(from: startDateText),
               date < startDate {
                DOOToast.show(message: "여행 종료일보다 여행 시작일이 빨라요!", insetFromBottom: ScreenUtils.getHeight(374))
            }
        }
        travelNameTextFieldCheck()
        updateCreateButtonState()
    }
    
    func didSelectDate(date: Date) {
        updateCreateButtonState()
    }
}

extension EditTravelViewController {
    func handleError(_ error: NetworkError) {
        switch error {
        case .serverError:
            DOOToast.show(message: "서버 오류", insetFromBottom: 80)
        case .unAuthorizedError, .reIssueJWT:
            DOOToast.show(message: "토큰만료, 재로그인필요", insetFromBottom: 80)
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            DOOToast.show(message: error.description, insetFromBottom: 80)
        }
    }
    
    func reIssueJWTToken() {
        Task {
            do {
                try await AuthService.shared.postReIssueJWTToken()
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
    
    // MARK: - Network
    
    func getAllTravelData(tripId: Int) {
        Task {
            do {
                self.travelData = try await TravelDetailService.shared.getTravelDetailInfo(tripId: tripId)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
    
    func patchTravelData() {
        Task {
            do {
                try await TravelDetailService.shared.patchTravelInfo(tripId: tripId, requestBody: patchRequestBody)
            }
            self.navigationController?.popToRootViewController(animated: false)
            DOOToast.show(message: "여행 정보가 수정되었어요", insetFromBottom: ScreenUtils.getHeight(103))
        }
    }
}
