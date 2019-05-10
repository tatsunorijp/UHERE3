//
//  Atividade+CoreDataProperties.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 16/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//
//

import Foundation
import CoreData


extension Atividade {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Atividade> {
        return NSFetchRequest<Atividade>(entityName: "Atividade")
    }

    @NSManaged public var alertaOffSet: Double
    @NSManaged public var anotacao: String?
    @NSManaged public var cor: String?
    @NSManaged public var diaHora: NSDate?
    @NSManaged public var local: String?
    @NSManaged public var nome: String?
    @NSManaged public var nota: Double
    @NSManaged public var peso: Double
    @NSManaged public var tipo: String?
    @NSManaged public var offSetString: String?
    @NSManaged public var relationship: Materia?

}
