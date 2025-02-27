//
//  LocalizedString.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 27.02.2025.
//

import Foundation

enum LocalizedString {
    enum Options {
        static var settingsTitle: String {
            return NSLocalizedString("options_screen_title", comment: SC.empty)
        }
        
        static var buttonTitle: String{
            return NSLocalizedString("add_notify_button_title", comment: SC.empty)
        }
        
        static var reminderText: String{
            return NSLocalizedString("options_reminder_Text", comment: SC.empty)
        }
        
        static var addReminderButtonTitle: String{
            return NSLocalizedString("add_reminder_button_title", comment: SC.empty)
        }
        
        static var faceIdText: String{
            return NSLocalizedString("face_id_text", comment: SC.empty)
        }
        
        static var add: String{
            return NSLocalizedString("add", comment: SC.empty)
        }
        
        static var cancel: String{
            return NSLocalizedString("cancel", comment: SC.empty)
        }
        
    }
    

}

