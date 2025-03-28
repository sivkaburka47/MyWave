//
//  LocalizedString.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 27.02.2025.
//

import Foundation

enum LocalizedString {
    
    enum Welcome {
        
        static var welcomeText: String {
            return NSLocalizedString("welcome_text", comment: SC.empty)
        }
    }
    
    enum Journal {
        
        static var titleText: String {
            return NSLocalizedString("journal_title_text", comment: SC.empty)
        }
        
        static var addNoteText: String {
            return NSLocalizedString("add_note_text", comment: SC.empty)
        }
        
        static var perDayText: String {
            return NSLocalizedString("per_day_text", comment: SC.empty)
        }
        
        static var seriesText: String {
            return NSLocalizedString("series_text", comment: SC.empty)
        }
        
        static var feelText: String {
            return NSLocalizedString("feel_text", comment: SC.empty)
        }
    }
    
    enum EmotionSelection {
        
        static var feelAdvice: String {
            return NSLocalizedString("feel_advice", comment: SC.empty)
        }
    }
    
    enum AddNote {
        
        static var feelText: String {
            return NSLocalizedString("feel_text", comment: SC.empty)
        }
        
        static var saveText: String {
            return NSLocalizedString("save_text", comment: SC.empty)
        }
    }
    
    enum Options {
        
        static var settingsTitle: String {
            return NSLocalizedString("options_screen_title", comment: SC.empty)
        }
        
        static var buttonTitle: String {
            return NSLocalizedString("add_notify_button_title", comment: SC.empty)
        }
        
        static var reminderText: String {
            return NSLocalizedString("options_reminder_Text", comment: SC.empty)
        }
        
        static var addReminderButtonTitle: String {
            return NSLocalizedString("add_reminder_button_title", comment: SC.empty)
        }
        
        static var faceIdText: String {
            return NSLocalizedString("face_id_text", comment: SC.empty)
        }
        
        static var add: String {
            return NSLocalizedString("add", comment: SC.empty)
        }
        
        static var cancel: String {
            return NSLocalizedString("cancel", comment: SC.empty)
        }
        
        static var profileName: String {
            return NSLocalizedString("profile_text", comment: SC.empty)
        }
    }
}

