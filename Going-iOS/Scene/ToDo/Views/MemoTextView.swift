//
//  MemoTextView.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/24/24.
//

import UIKit

protocol MemoTextViewDelegate: AnyObject {
    func checkMemoState()
}

class MemoTextView: UIView {
    
    private let memoLabel = DOOLabel(
        font: .pretendard(.body2_bold),
        color: UIColor(resource: .gray700),
        text: StringLiterals.ToDo.memo
    )
    
    let memoTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor(resource: .white000)
        tv.textContainerInset = UIEdgeInsets(
            top: ScreenUtils.getHeight(12),
            left: ScreenUtils.getWidth(12),
            bottom: ScreenUtils.getHeight(12),
            right: ScreenUtils.getWidth(32)
        )
        tv.font = .pretendard(.body3_medi)
        tv.textColor = UIColor(resource: .gray200)
        tv.layer.borderColor = UIColor(resource: .gray200).cgColor
        tv.layer.cornerRadius = 6
        tv.layer.borderWidth = 1
        return tv
    }()
   
    private lazy var clearButton: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(resource: .btnDelete), for: .normal)
        btn.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        return btn
    }()
    
    private let countMemoCharacterLabel = DOOLabel(
        font: .pretendard(.detail2_regular),
        color: UIColor(resource: .gray200),
        text: "0/1000"
    )
    
    private let memoWarningLabel: DOOLabel = {
        let label = DOOLabel(font: .pretendard(.detail2_regular), color: UIColor(resource: .red500))
        label.isHidden = true
        return label
    }()
    
    
    var memoTextViewCount: Int = 0
    
    var memoTextviewPlaceholder: String = ""
    
    weak var delegate: MemoTextViewDelegate?
    
    lazy var navigationBarTitle: String = "" {
        didSet {
            if navigationBarTitle != StringLiterals.ToDo.inquiry {
                self.addSubview(countMemoCharacterLabel)
                
                countMemoCharacterLabel.snp.makeConstraints{
                    $0.top.equalTo(memoTextView.snp.bottom).offset(4)
                    $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(4))
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInquiryMemoStyle() {
        guard let memotext = memoTextView.text?.count else {return}
        memoTextView.layer.borderColor = memoTextView.text == "" ? UIColor(resource: .gray200).cgColor : UIColor(resource: .gray700).cgColor
        memoTextView.textColor = memoTextView.text == "" ? UIColor(resource: .gray200) : UIColor(resource: .gray700)
        countMemoCharacterLabel.text = "\(memotext)/1000"
        countMemoCharacterLabel.textColor = memoTextView.text == "" ? UIColor(resource: .gray200) : UIColor(resource: .gray700)
    }

}

private extension MemoTextView {
    
    func setHierarchy() {
        self.addSubviews(memoLabel,
                         memoTextView,
                         memoWarningLabel,
                         clearButton)
    }
    
    func setLayout() {
        memoLabel.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(24))
        }
       
        memoTextView.snp.makeConstraints{
            $0.top.equalTo(memoLabel.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(140))
        }
        
        clearButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(42))
            $0.size.equalTo(ScreenUtils.getHeight(20))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(12))
        }
        
        memoWarningLabel.snp.makeConstraints {
            $0.top.equalTo(memoTextView.snp.bottom).offset(4)
            $0.leading.equalTo(memoTextView.snp.leading).offset(4)
        }
    }
    
    func setDelegate() {
        memoTextView.delegate = self
    }
    
    func memoTextViewBlankCheck() {
        guard let textEmpty = memoTextView.text?.isEmpty else { return }
        if textEmpty {
            memoTextView.layer.borderColor = UIColor(resource: .gray200).cgColor
            self.countMemoCharacterLabel.textColor = UIColor(resource: .gray200)
            clearButton.isHidden = true
            clearButton.isEnabled = false
        } else {
            memoTextView.layer.borderColor = UIColor(resource: .gray700).cgColor
            self.countMemoCharacterLabel.textColor = UIColor(resource: .gray400)
            clearButton.isHidden = false
            clearButton.isEnabled = true
        }
    }
    
    func textViewCountCheck() {
        
        guard let text = memoTextView.text else { return }
        
        if text.count > 1000 {
            memoTextView.layer.borderColor = UIColor(resource: .red500).cgColor
            countMemoCharacterLabel.textColor = UIColor(resource: .red500)
            memoWarningLabel.text = "메모는 1000자를 초과할 수 없습니다."
            memoWarningLabel.isHidden = false
        } else {
            memoWarningLabel.isHidden = true
        }
    }
    
    @objc
    func clearText() {
        memoTextView.text = ""
        countMemoCharacterLabel.text = "\(memoTextView.text.count)/1000"
        textViewCountCheck()
        memoTextViewBlankCheck()
    }
    
}

extension MemoTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        textView.becomeFirstResponder()
        
        if textView.text == memoTextviewPlaceholder {
            textView.text = ""
            textView.textColor = UIColor(resource: .gray700)
        } else {
            clearButton.isHidden = false
            clearButton.isEnabled = true
        }

        textViewCountCheck()
        memoTextViewBlankCheck()
        self.delegate?.checkMemoState()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = memoTextviewPlaceholder
            textView.textColor = UIColor(resource: .gray200)
            textViewCountCheck()
        }
        
        clearButton.isHidden = true
        clearButton.isEnabled = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == memoTextView {
            let memoTextViewCount = textView.text.count
            countMemoCharacterLabel.text = "\(memoTextViewCount)/1000"
            memoTextViewBlankCheck()
            textViewCountCheck()
            self.delegate?.checkMemoState()
        }
    }
}
