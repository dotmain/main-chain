//
//  CreateDataBlock.swift
//  
//
//  Created by Ω on 10/1/21.
//

import Fluent

struct CreateDataModelMigrator: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        print("MIGRATION DataModel")
        return database.schema(DataModelFields.schema.rawValue.description)
            .id()
            .field(DataModelFields.log.rawValue, .string, .required)
            .field(DataModelFields.value.rawValue, .double, .required)
            .field(DataModelFields.log.rawValue, .double, .required)
            .field(DataModelFields.total.rawValue, .double, .required)
            .field(DataModelFields.identifier.rawValue, .string, .required)
            .field(DataModelFields.createdAt.rawValue, .date)
            .unique(on: DataModelFields.id.rawValue)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(DataModelFields.schema.rawValue.description).delete()
    }
}
