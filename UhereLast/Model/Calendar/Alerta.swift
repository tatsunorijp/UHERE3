//
//  Alerta.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 29/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import Foundation
import EventKit

class Alerta{


    static func save(calendar: String, title: String, starDate: Date, endDate: Date, isAllDay: Bool, offSet: Double, weekDaysSelecteded: [EKRecurrenceDayOfWeek], finalDate: Date){
        let eventStore: EKEventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)

        for calendarEvent in calendars {
            if calendarEvent.title == calendar{
                
                eventStore.requestAccess(to: .event, completion: { (granted, error) in
                    if (granted) && (error == nil){
                        let event: EKEvent = EKEvent(eventStore: eventStore)
                        
                        event.title = title
                        event.startDate = starDate
                        event.endDate = endDate
                        event.isAllDay = isAllDay
                        event.calendar = calendarEvent
                        
                        if weekDaysSelecteded.count > 0 {
                            let recurrenceRule = EKRecurrenceRule.init(
                                recurrenceWith: .daily,
                                interval: 1,
                                daysOfTheWeek: weekDaysSelecteded,
                                daysOfTheMonth: nil,
                                monthsOfTheYear: nil,
                                weeksOfTheYear: nil,
                                daysOfTheYear: nil,
                                setPositions: nil,
                                end: EKRecurrenceEnd.init(end:finalDate)
                            )
                            
                            event.recurrenceRules = [recurrenceRule]
                        }
                        
                        if(offSet >= 0){
                            let alarm = EKAlarm(relativeOffset: -offSet)
                            event.alarms = [alarm]
                        }
                        
                        do {
                            try eventStore.save(event, span: .thisEvent)
                        } catch let error as NSError {
                            print("failed to save event with error : \(error)")
                        }
                        print("Saved Event")
                        
                    }else{
                        print("failed to save event with error : \(String(describing: error)) or access not granted")
                    }
                })
            }else{
                print("erro ao buscar calendario")
            }
        }
    }
}
