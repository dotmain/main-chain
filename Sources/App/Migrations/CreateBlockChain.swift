//
//  File.swift
//  
//
//  Created by Ω on 10/1/21.
//

import Fluent

struct CreateBlockChainMigrator: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        print("MIGRATION BlockChain")
        return database.schema(BlockChainFields.schema.rawValue.description)
            .id()
            .field(BlockModelFields.dataModels.rawValue, .array(of: .custom(BlockModel.self)), .required)
            .field(BlockModelFields.identifier.rawValue, .string, .required)
            .field(BlockModelFields.createdAt.rawValue, .date)
            .unique(on: BlockChainFields.id.rawValue)
            .unique(on: BlockChainFields.identifier.rawValue)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(BlockChainFields.schema.rawValue.description).delete()
    }
}
