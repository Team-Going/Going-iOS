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
        static var buttonSave: UIImage { .load(named: "btn_save")}
        static var buttonClose: UIImage { .load(named: "btn_close")}
    }
    
    enum Splash {
        static var splashLogo: UIImage { .load(named: "splash_logo") }
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
    }
    
    enum TravelTest {
        static var indexImage: UIImage { .load(named: "round_background_image")}
    }
    
    enum ToDo {
        static var enabledDropdown: UIImage { .load(named: "enabled_ic_dropdown") }
        static var disabledDropdown: UIImage { .load(named: "disabled_ic_dropdown") }
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
}
