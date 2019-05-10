//
//  Prova+CoreDataProperties.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 16/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//
//

import Foundation
import CoreData


extension Prova {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Prova> {
        return NSFetchRequest<Prova>(entityName: "Prova")
    }

    @NSManaged public var alertaOffSet: Double
    @NSManaged public var diaHora: NSDate?
    @NSManaged public var nome: String?
    @NSManaged public var nota: Double
    @NSManaged public var peso: Double
    @NSManaged public var offSetString: String?
    @NSManaged public var materia: Materia?

}
