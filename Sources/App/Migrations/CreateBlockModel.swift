//
//  File.swift
//  
//
//  Created by Ω on 10/1/21.
//

import Fluent

struct CreateBlockModelMigrator: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        print("MIGRATION BlockModel")
        return database.schema(BlockModelFields.schema.rawValue.description)
            .id()
            .field(BlockModelFields.index.rawValue, .int, .required)
            .field(BlockModelFields.nonse.rawValue, .int, .required)
            .field(BlockModelFields.previousHash.rawValue, .string, .required)
            .field(BlockModelFields.hash.rawValue, .string, .required)
            .field(BlockModelFields.identifier.rawValue, .string, .required)
            .field(BlockModelFields.dataModels.rawValue, .array(of: .custom(DataModel.self)), .required)
            .field(BlockModelFields.createdAt.rawValue, .datetime)
            .unique(on: BlockModelFields.id.rawValue)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(DataModelFields.schema.rawValue.description).delete()
    }
}
