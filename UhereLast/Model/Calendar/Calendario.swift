//
//  Calendario.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 29/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import Foundation
import EventKit
class Calendario{
    static let mainCalendarName = "UHereCalendar"
    static var mainCalendar: EKCalendar?
    
    static func createCalendar(title: String){
        let eventStore = EKEventStore();
        
        let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        
        newCalendar.title = title
        
        //let sourcesInEventStore = eventStore.sources

        newCalendar.source = eventStore.defaultCalendarForNewEvents!.source
        
        // Save the calendar using the Event Store instance
        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            UserDefaults.standard.set(newCalendar.calendarIdentifier, forKey: "EventTrackerPrimaryCalendar")
            mainCalendar = newCalendar
        } catch {
            print("Erro na criacao do calendario")
        }
    }
    
    static func deleteCalendar(title: String){
        let eventStore = EKEventStore()
        
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == title {
                do {
                    try eventStore.removeCalendar(calendar, commit: true)
                } catch {
                    print("Erro na remocao do calendario")
                }
            }
        }
    }
    
    static func isMainCalendarCreated() -> Bool {
        let eventStore = EKEventStore()
        
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            // 2
            if calendar.title == self.mainCalendarName {
                return true
            }
        }
        return false
    }
    
    static func setMainCalendar(){
        let eventStore = EKEventStore()
        
        let calendars = eventStore.calendars(for: .event)
        for calendar in calendars {
            if calendar.title == self.mainCalendarName {
                self.mainCalendar = calendar
            }
        }
    }
    
    /*static func getCalendar(title: String) -> EKCalendar{
        let eventStore = EKEventStore()

        let calendars = eventStore.calendars(for: .event)
        for calendar in calendars {
            if calendar.title == title {
                return calendar
            }
        }
        let falso = EKCalendar(for: .event, eventStore: eventStore)
        falso.title = "falso"
        return falso
    }*/
}
