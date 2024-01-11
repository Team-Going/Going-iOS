//
//  ImageLiterals.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//

import UIKit

enum ImageLiterals {
    
    enum NavigationBar {
        static var buttonBack: UIImage { .load(named: "btn_back") }
        static var buttonSave: UIImage { .load(named: "btn_save") }
        static var buttonClose: UIImage { .load(named: "btn_close") }
        static var buttonProfile: UIImage { .load(named: "btn_profile") }
    }
    
    enum Splash {
        static var splashLogo: UIImage { .load(named: "splash_logo") }
        static var userTestSplash: UIImage { .load(named: "img_testsplash") }
    }
    
    enum Login {
        static var loginLogo: UIImage { .load(named: "login_logo") }
        static var warningImage: UIImage { .load(named: "ic_warning_mini") }
        static var kakaoLoginButton: UIImage { .load(named: "kakao_login_large_wide") }
        static var appleLoginButton: UIImage { .load(named: "btn_applelogin") }
    }
    
    enum TestResult {
        static var dotImage: UIImage { .load(named: "resultDot") }
        static var verticalLine: UIImage { .load(named: "verti_line") }
    }
    
    enum CreateTravel {
        static var buttonCopy: UIImage { .load(named: "ic_copy")}
        static var ticketImage: UIImage { .load(named: "ticket_img_small")}
        static var larvaImage: UIImage { .load(named: "larva")}
    }
    
    enum OurToDo {
        static var btnBack: UIImage { .load(named: "btn_back") }
        static var ticketBox: UIImage { .load(named: "ticket_box") }
        static var btnOurToDoEdit: UIImage { .load(named: "btn_ourtodo_edit") }
        static var icCalendar: UIImage { .load(named: "ic_calendar") }
        static var btnEnter: UIImage { .load(named: "btn_enter")}
        static var btnPlus: UIImage { .load(named: "btn_plus") }
        static var btnPlusOurToDo: UIImage { .load(named: "btn_plus_ourtodo") }
        static var emptyViewIcon: UIImage { .load(named: "img_ourtodo_empty") }
        static var mainViewIcon: UIImage { .load(named: "img_ourtodo_main") }
    }
    
    enum TravelTest {
        static var indexImage: UIImage { .load(named: "round_background_image")}
    }
    
    enum ToDo {
        static var enabledDropdown: UIImage { .load(named: "enabled_ic_dropdown") }
        static var disabledDropdown: UIImage { .load(named: "disabled_ic_dropdown") }
        static var tappedDropdown: UIImage { .load(named: "tap_ic_dropdown") }
    }
    
    enum MyToDo {
        static var btnCheckBoxIncomplete: UIImage {
            .load(named: "btn_checkbox_incomplete")
        }
        static var btnCheckBoxComplete: UIImage {
            .load(named: "btn_checkbox_complete")
        }
        static var icLockDark: UIImage {
            .load(named: "ic_lock_dark")
        }
        static var icLockLight: UIImage {
            .load(named: "ic_lock_light")
        }
        static var emptyViewIcon: UIImage {
            .load(named: "img_mytodo_empty")
        }
        static var mainViewIcon: UIImage {
            .load(named: "img_mytodo_main")
        }
    }
    enum DashBoard {
        static var btnSetting: UIImage { .load(named: "btn_setting") }
        static var btnSave: UIImage { .load(named: "btn_save") }
        static var btnProfile: UIImage { .load(named: "btn_profile") }
    }
    
    enum Settings {
        static var btnResign: UIImage { .load(named: "ic_unsubscribe") }
        static var btnEnterLarge: UIImage { .load(named: "btn_enter_large")}
    }
    
    enum TabBar {
        static var tabbarMyToDoUnselected: UIImage { .load(named: "tabbar_mytodo_unselected") }
        static var tabbarOurToDoSelected: UIImage { .load(named: "tabbar_ourtodo_selected") }
        static var tabbarOurToDoUnselected: UIImage { .load(named: "tabbar_ourtodo_unselected") }
        static var tabbarMyToDoSelected: UIImage { .load(named: "tabbar_mytodo_selected") }
    enum UserTestTypeCharacter {
        static var aeiCharac: UIImage { .load(named: "img_testresult_aei")}
        static var aepCharac: UIImage { .load(named: "img_testresult_aep")}
        static var ariCharac: UIImage { .load(named: "img_testresult_ari")}
        static var arpCharac: UIImage { .load(named: "img_testresult_arp")}
        static var seiCharac: UIImage { .load(named: "img_testresult_sei")}
        static var sepCharac: UIImage { .load(named: "img_testresult_sep")}
        static var sriCharac: UIImage { .load(named: "img_testresult_sri")}
        static var srpCharac: UIImage { .load(named: "img_testresult_srp")}
    }
    
    enum UserTest {
        static var background: UIImage { .load(named: "img_test")}
    }
}
