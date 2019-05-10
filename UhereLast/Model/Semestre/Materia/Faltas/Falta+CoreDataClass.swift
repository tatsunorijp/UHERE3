//
//  Falta+CoreDataClass.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 29/04/19.
//  Copyright © 2019 tatsu. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Falta)
public class Falta: NSManagedObject {
    
    convenience init?(falta: Date) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        self.init(entity: Falta.entity(), insertInto: managedContext)
        self.dia = falta as NSDate
    }
    
    static func save(falta: Falta, materia: Materia){
        materia.addToRawFaltas(falta)
        do{
            try falta.managedObjectContext?.save()
        } catch {
            print("Erro ao cadastrar nova falta")
        }
    }
    
    
    static func delete(falta: Falta){
        falta.managedObjectContext?.delete(falta)
        do{
            try falta.managedObjectContext?.save()
        } catch {
            print("Erro ao excluir falta")
        }
     }
    
}
