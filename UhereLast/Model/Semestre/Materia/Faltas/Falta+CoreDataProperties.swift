//
//  Falta+CoreDataProperties.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 29/04/19.
//  Copyright © 2019 tatsu. All rights reserved.
//
//

import Foundation
import CoreData


extension Falta {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Falta> {
        return NSFetchRequest<Falta>(entityName: "Falta")
    }

    @NSManaged public var dia: NSDate?
    @NSManaged public var materia: Materia?

}
