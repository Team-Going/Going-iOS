//
//  ToDoTextFieldView.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/24/24.
//

import UIKit

import SnapKit

protocol ToDoTextFieldDelegate: AnyObject {
    func todoTextFieldDidChange()
    func checkTextFieldState()
}

class ToDoTextFieldView: UIView {

    private let todoLabel = DOOLabel(
        font: .pretendard(.body2_bold),
        color: .gray700,
        text: StringLiterals.ToDo.todo
    )
    lazy var todoTextfield: UITextField = {
        let tf = UITextField()
        tf.setTextField(forPlaceholder: "", forBorderColor: .gray200, forCornerRadius: 6)
        tf.font = .pretendard(.body3_medi)
        tf.setPlaceholderColor(.gray700)
        tf.textColor = .gray700
        tf.backgroundColor = .white000
        tf.setLeftPadding(amount: 12)
        tf.addTarget(self, action: #selector(todoTextFieldChange), for: .editingChanged)
        return tf
    }()
    private let warningLabel: DOOLabel = {
        let label = DOOLabel(font: .pretendard(.body3_medi), color: .red400)
        label.isHidden = true
        return label
    }()
    lazy var countToDoCharacterLabel = DOOLabel(
        font: .pretendard(.detail2_regular),
        color: .gray200,
        text: "0/15"
    )
    
    
    weak var delegate: ToDoTextFieldDelegate?
    var todoTextFieldCount: Int = 0
    private var isTodoTextFieldGood: Bool = false
    var todoTextfieldPlaceholder: String = ""

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInquiryTextFieldStyle() {
        guard let todotext = todoTextfield.placeholder?.count else {return}
        todoTextfield.layer.borderColor = UIColor.gray700.cgColor
        todoTextfield.setPlaceholderColor(.gray700)
        countToDoCharacterLabel.textColor = .gray700
        countToDoCharacterLabel.text = "\(todotext)/15"
    }

    
    func todoTextFieldCheck() {
        guard let text = todoTextfield.text else { return }
        
        if text.count > 15 {
            todoTextfield.layer.borderColor = UIColor.red500.cgColor
            countToDoCharacterLabel.textColor = .red500
            warningLabel.text = "내용은 15자 이하여야 합니다"
            warningLabel.isHidden = false
            self.isTodoTextFieldGood = false
            
        } else if text.count == 0 {
            todoTextfield.layer.borderColor = UIColor.gray200.cgColor
            countToDoCharacterLabel.textColor = .gray200
            warningLabel.isHidden = true
            self.isTodoTextFieldGood = false
            
        } else if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.isTodoTextFieldGood = false
            
            todoTextfield.layer.borderColor = UIColor.red500.cgColor
            countToDoCharacterLabel.textColor = .red500
            warningLabel.text = "내용에는 공백만 입력할 수 없어요"
            warningLabel.isHidden = false
        }  else {
            todoTextfield.layer.borderColor = UIColor.gray700.cgColor
            countToDoCharacterLabel.textColor = .gray700
            warningLabel.isHidden = true
            self.isTodoTextFieldGood = true
        }
        
        countToDoCharacterLabel.text = "\(text.count)/15"
        self.delegate?.checkTextFieldState()
    }
    
    @objc
    func todoTextFieldChange() {
        self.delegate?.todoTextFieldDidChange()
    }
    
}

private extension ToDoTextFieldView {
    
    func setHierarchy() {
        self.addSubviews(todoLabel, todoTextfield, warningLabel ,countToDoCharacterLabel)
    }
    
    func setLayout() {
        todoLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(23))
        }
        todoTextfield.snp.makeConstraints{
            $0.top.equalTo(todoLabel.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(48))
        }
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(todoTextfield.snp.bottom).offset(4)
            $0.leading.equalTo(todoTextfield.snp.leading).offset(4)
        }
        countToDoCharacterLabel.snp.makeConstraints{
            $0.top.equalTo(todoTextfield.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(4))
        }
    }
}

extension ToDoTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing (_ textField: UITextField) {
        self.delegate?.checkTextFieldState()
        todoTextFieldCheck()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        todoTextFieldCheck()
        self.delegate?.checkTextFieldState()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        return true
    }
    
    /// 엔터 키 누르면 키보드 내리는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
