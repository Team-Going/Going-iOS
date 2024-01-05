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
}
