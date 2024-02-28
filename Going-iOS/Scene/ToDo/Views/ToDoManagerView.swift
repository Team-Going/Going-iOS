//
//  ToDoManagerCollectionView.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/24/24.
//

import UIKit

protocol ToDoManagerViewDelegate: AnyObject {
    func tapToDoManagerButton(_ sender: UIButton)
}

class ToDoManagerView: UIView {

    private let managerLabel: UILabel = DOOLabel(
        font: .pretendard(.body2_bold),
        color: UIColor(resource: .gray700),
        text: StringLiterals.ToDo.allocation
    )
    
    let todoManagerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(ToDoManagerCollectionViewCell.self, forCellWithReuseIdentifier: ToDoManagerCollectionViewCell.identifier)
        return collectionView
    }()

    var fromOurTodoParticipants: [Participant] = []
    
    var allocators: [Allocators] = []
    
    var beforeVC: String = ""
    
    var navigationBarTitle: String = ""
    
//    var isActivateView: Bool = true
    
    var isSecret: Bool = false
    
    weak var delegate: ToDoManagerViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 담당자 버튼 클릭 시 버튼 스타일 변경해주는 메소드
    func changeButtonConfig(isSelected: Bool, btn: UIButton) {
        if !isSelected {
            btn.setTitleColor(UIColor(resource: .white000), for: .normal)
            btn.backgroundColor = btn.tag == 0 ? UIColor(resource: .red500) : UIColor(resource: .gray400)
            btn.layer.borderColor = btn.tag == 0 ? UIColor(resource: .red500).cgColor : UIColor(resource: .gray400).cgColor
        }else {
            btn.setTitleColor(UIColor(resource: .gray300), for: .normal)
            btn.backgroundColor = UIColor(resource: .white000)
            btn.layer.borderColor = UIColor(resource: .gray300).cgColor
        }
    }
    
    // 담당자 버튼 탭 시 버튼 색상 변경 & 배열에 담아주는 메서드
    @objc
    func didTapToDoManagerButton(_ sender: UIButton) {
        self.delegate?.tapToDoManagerButton(sender)
    }
}

private extension ToDoManagerView {
    
    func setHierarchy() {
        self.addSubviews(managerLabel, todoManagerCollectionView)
    }
    
    func setLayout() {
        managerLabel.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(23))
        }
        
        todoManagerCollectionView.snp.makeConstraints{
            $0.top.equalTo(managerLabel.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(24))
        }
    }
    
    func setDelegate() {
        todoManagerCollectionView.delegate = self
        todoManagerCollectionView.dataSource = self
    }

}


// MARK: - Extension

extension ToDoManagerView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 마이투두 - 할일추가 - 1로 픽스
        
        if beforeVC == "our" {
            if navigationBarTitle == "추가" {
                return self.fromOurTodoParticipants.count
            } else {
                return self.allocators.count
            }
        }
        else {
            return self.allocators.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let managerCell = collectionView.dequeueReusableCell(withReuseIdentifier: ToDoManagerCollectionViewCell.identifier, for: indexPath) as? ToDoManagerCollectionViewCell else {return UICollectionViewCell()}
        
        var name = ""
        if beforeVC == "our" {
            if navigationBarTitle == "추가" {
                name = fromOurTodoParticipants[indexPath.row].name
            } else {
                name = allocators[indexPath.row].name
            }
        } else {
            name = allocators[indexPath.row].name
        }
        
        managerCell.managerButton.isEnabled = true
        managerCell.managerButton.setTitle(name, for: .normal)
        managerCell.managerButton.tag = indexPath.row
        managerCell.managerButton.addTarget(self, action: #selector(didTapToDoManagerButton(_:)), for: .touchUpInside)
        //아워투두 -> 조회
        //다 선택된 옵션
        //마이투두 -> 조회
        //혼자할일 + 라벨
        //아워투두
        if beforeVC == "our" {
            managerCell.managerButton.isSelected = self.navigationBarTitle == StringLiterals.ToDo.inquiry ? true : false

            // 추가
            if self.navigationBarTitle == StringLiterals.ToDo.add {
                managerCell.managerButton.backgroundColor = UIColor(resource: .white000)
                managerCell.managerButton.setTitleColor(UIColor(resource: .gray300), for: .normal)
                managerCell.managerButton.layer.borderColor = UIColor(resource: .gray300).cgColor
            } else {
                //조회 & 수정
                managerCell.managerButton.setTitleColor(UIColor(resource: .white000), for: .normal)
                if allocators[indexPath.row].isOwner {
                    managerCell.managerButton.backgroundColor = UIColor(resource: .red500)
                    managerCell.managerButton.layer.borderColor = UIColor(resource: .red500).cgColor
                } else {
                    managerCell.managerButton.backgroundColor = UIColor(resource: .gray400)
                    managerCell.managerButton.layer.borderColor = UIColor(resource: .gray400).cgColor
                }
            }
        }// 마이투두
        else {
            // 조회
            if self.navigationBarTitle == StringLiterals.ToDo.inquiry {
                managerCell.managerButton.isSelected = true
                // 혼자 할 일
                if self.isSecret == true {
                    //설명라벨 세팅
                    if allocators[indexPath.row].name == "나만 볼 수 있는 할일이에요" {
                        managerCell.managerButton.isEnabled = false
                        managerCell.managerButton.backgroundColor = UIColor(resource: .white000)
                        managerCell.managerButton.layer.borderColor = UIColor(resource: .white000).cgColor
                        
                        managerCell.managerButton.setTitleColor(UIColor(resource: .gray200), for: .normal)
                    } else {
                        managerCell.managerButton.setImage(UIImage(resource: .icLock), for: .normal)
                        managerCell.managerButton.setTitleColor(UIColor(resource: .red500), for: .normal)
                        managerCell.managerButton.layer.borderColor = UIColor(resource: .red500).cgColor
                        managerCell.managerButton.backgroundColor = UIColor(resource: .white000)
                    }
                } else{
                    managerCell.managerButton.setTitleColor(UIColor(resource: .white000), for: .normal)
                    if allocators[indexPath.row].isOwner { //owner
                        managerCell.managerButton.backgroundColor = UIColor(resource: .red500)
                        managerCell.managerButton.layer.borderColor = UIColor(resource: .red500).cgColor
                    }else {
                        managerCell.managerButton.backgroundColor = UIColor(resource: .gray400)
                        managerCell.managerButton.layer.borderColor = UIColor(resource: .gray400).cgColor
                    }
                }
            }// 추가
            else if self.navigationBarTitle == StringLiterals.ToDo.add {
                //설명라벨 세팅
                if allocators[indexPath.row].name == "나만 볼 수 있는 할일이에요" {
                    managerCell.managerButton.isEnabled = true
                    managerCell.managerButton.backgroundColor = UIColor(resource: .white000)
                    managerCell.managerButton.layer.borderColor = UIColor(resource: .white000).cgColor
                    managerCell.managerButton.setTitleColor(UIColor(resource: .white000), for: .normal)
                } else {
                    managerCell.managerButton.setImage(UIImage(resource: .icLock), for: .normal)
                    managerCell.managerButton.setTitleColor(UIColor(resource: .red500), for: .normal)
                    managerCell.managerButton.layer.borderColor = UIColor(resource: .red500).cgColor
                    managerCell.managerButton.backgroundColor = UIColor(resource: .white000)
                    managerCell.managerButton.isUserInteractionEnabled = false
                }
            }
        }
        return managerCell
    }
}

extension ToDoManagerView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ScreenUtils.getWidth(3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ScreenUtils.getWidth(3)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        if beforeVC == "my" {
            if navigationBarTitle == "추가" {
               return CGSize(width: ScreenUtils.getWidth(66), height: ScreenUtils.getHeight(20))
                
            //조회
            } else {
                if self.isSecret == true {
                    if indexPath.row == 0 {
                        return CGSize(width: ScreenUtils.getWidth(66), height: ScreenUtils.getHeight(20))
                    } else {
                        return CGSize(width: ScreenUtils.getWidth(140), height: ScreenUtils.getHeight(18))
                    }
                } else {
                    return CGSize(width: ScreenUtils.getWidth(42), height: ScreenUtils.getHeight(20))
                    
                }
            }
        }
        return CGSize(width: ScreenUtils.getWidth(42), height: ScreenUtils.getHeight(20))
    }
}
