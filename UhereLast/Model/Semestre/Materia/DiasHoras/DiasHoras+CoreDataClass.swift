//
//  DiasHoras+CoreDataClass.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 17/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(DiasHoras)
public class DiasHoras: NSManagedObject {

    convenience init?(dias: [Bool], horas: [Date]) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        self.init(entity: DiasHoras.entity(), insertInto: managedContext)
        
        self.domingo = dias[0];      self.hDomingo = horas[0] as NSDate
        self.segunda = dias[1];      self.hSegunda = horas[1] as NSDate
        self.terca =   dias[2];      self.hTerca =   horas[2] as NSDate
        self.quarta =  dias[3];      self.hQuarta =  horas[3] as NSDate
        self.quinta =  dias[4];      self.hQuinta =  horas[4] as NSDate
        self.sexta =   dias[5];      self.hSexta =   horas[5] as NSDate
        self.sabado =  dias[6];      self.hSabado =  horas[6] as NSDate
        
        
    }
    
    static func save(diasHoras: DiasHoras, materia: Materia){
        materia.diasHoras = diasHoras
        do{
            try diasHoras.managedObjectContext?.save()
        } catch {
            print("Erro ao salvar horário")
        }
    }
    
    static func change(diasHoras: DiasHoras){
        do{
            try diasHoras.managedObjectContext?.save()
        } catch {
            print("Erro ao salvar horário")
        }
    }
    
    static func delete(diasHoras: DiasHoras){
        diasHoras.managedObjectContext?.delete(diasHoras)
        do{
            try diasHoras.managedObjectContext?.save()
        } catch {
            print("Erro ao excluir horário")
        }
    }
}
