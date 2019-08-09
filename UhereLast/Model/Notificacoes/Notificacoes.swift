//
//  Notificacoes.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 31/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class Notificacoes{
    static let aulaString = "Não se esqueça da sua aula"
    
    static func create(title: String, body: String, date: Date, offSet: Double, id: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.subtitle = Controller.Tipos.Indefinido.tipo()

        
        let offSetDate = date.addingTimeInterval( -(offSet * 60))
        
        
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: offSetDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = id
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        let notificationCenter =
        UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                print(error ?? "erro")
            }
        }
        
    }
    
    static func createNotificationForMateria(content: UNMutableNotificationContent, dias: [Bool], horas: [Date], offSet: Double, id: [String]){
        
        
        var count: Int = 0
        for i in 0...dias.count - 1{
            if(dias[i]){
                createSingleNotificationForMateria(content: content, hora: horas[i], offSet: offSet, weekDay: i+1, id: id[count])
                count = count + 1
            }
        }
    }
    
    static private func createSingleNotificationForMateria(content: UNMutableNotificationContent, hora: Date, offSet: Double, weekDay: Int, id: String){
        
        let offSetDate = hora.addingTimeInterval( -(offSet * 60))
        
        //let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: offSetDate)
        
        var dateComponents = DateComponents()
        dateComponents.weekday = weekDay
        dateComponents.hour = Calendar.current.component(.hour, from: offSetDate)
        dateComponents.minute = Calendar.current.component(.minute, from: offSetDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let uuidString = id
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        let notificationCenter =
            UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                print(error ?? "erro")
            }
            
        }
    }
    
    static func delete(id: [String]){
        let notificationCenter =
            UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: id)
        
    }
    
    static func update(title: String, oldId: String, newId: String?, body: String, date: Date, offSet: Double){
        self.delete(id: [oldId])
        
        if let newId = newId {
            self.create(title: title, body: body, date: date, offSet: offSet, id: newId)
        }
    }
    
    static func completeUpdate(title: String, oldId: String, newId: String, body: String, date: Date, offSet: Double) {
        self.delete(id: [oldId])
        
        if (offSet >= 0) {
            self.create(title: title, body: body, date: date, offSet: offSet, id: newId)
        }
    }
    
    static func updateForMateria(content: UNMutableNotificationContent, dias: [Bool], horas: [Date], offSet: Double, oldIds: [String], newIds: [String]){
        self.delete(id: oldIds)
        createNotificationForMateria(content: content, dias: dias, horas: horas, offSet: offSet, id: newIds)
    }
    static func getNotifications(){
        let notificationCenter =
            UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests { (notifications) in
            for notification in notifications{
                print(notification.identifier)
            }
        }
    }
    
    static func createContent(title: String, body: String, subtitle: String) -> UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        return content
    }
    
    static func idGenerator(type: String, materia: String, title: String, date: Date?) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy - h:mm a"
        
        if(date != nil){
            return type + materia + title + dateFormatter.string(from: date!)
        }
        return type + materia + title
    }
    
    static func idGeneratorForMateria(type: String, materia: String, weekday: String) -> String{
        return type + materia + weekday
    }
    
    static func secureCreate(){
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            // Do not schedule notifications if not authorized.
            guard settings.authorizationStatus == .authorized else {
                print("Pedir permissão")
                return
            }
            
            if settings.alertSetting == .enabled {
                // Schedule an alert-only notification.
                print("Pode criar")
            }
            else {
                // Schedule a notification with a badge and sound.

            }
        }
    }

}
