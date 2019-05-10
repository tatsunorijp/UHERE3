//
//  DiasHoras+CoreDataProperties.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 17/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//
//

import Foundation
import CoreData


extension DiasHoras {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiasHoras> {
        return NSFetchRequest<DiasHoras>(entityName: "DiasHoras")
    }

    @NSManaged public var segunda: Bool
    @NSManaged public var terca: Bool
    @NSManaged public var quarta: Bool
    @NSManaged public var quinta: Bool
    @NSManaged public var sexta: Bool
    @NSManaged public var sabado: Bool
    @NSManaged public var domingo: Bool
    @NSManaged public var hSegunda: NSDate?
    @NSManaged public var hTerca: NSDate?
    @NSManaged public var hQuarta: NSDate?
    @NSManaged public var hQuinta: NSDate?
    @NSManaged public var hSexta: NSDate?
    @NSManaged public var hSabado: NSDate?
    @NSManaged public var hDomingo: NSDate?
    @NSManaged public var materia: Materia?

}
