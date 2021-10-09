//
//  File.swift
//  
//
//  Created by Ω on 10/9/21.
//

import Vapor
import Fluent

struct BlockModelController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let chain = routes
            .grouped("datamodel")
        chain.get(use: index)
        chain.group(":identifier") { route in
            route.get(use: indexIdentifier)
        }
        
        print("Router Set")
    }

    func index(req: Request) throws -> EventLoopFuture<[BlockModel]> {
        req.blocks()
    }
    
    func indexIdentifier(req: Request) throws -> EventLoopFuture<[BlockModel]> {
        try req.findBlocks()
    }
}

extension Request {
    
    func filterBlock() throws -> String {
        guard
            let license = parameters.get(BlockChainFields.identifier.rawValue.description)
        else { throw Abort(.internalServerError, reason: "Request unexpectedly missing identifier parameter") }
        return license
    }
        
    func blocks() -> EventLoopFuture<[BlockModel]> {
        BlockModel
            .query(on: db)
            .all()
    }
    
    func findBlocks() throws -> EventLoopFuture<[BlockModel]> {
        let identifier = try filterBlock()
        return try findBlocks(with: identifier)
    }
    
    func findBlocks(with identifier: String) throws -> EventLoopFuture<[BlockModel]> {
        return BlockModel
            .query(on: db)
            .filter(\.$identifier == identifier)
            .all()
            .guard({ chain in
                chain.filter({!$0.valid}).count == 0
            }, else: ChainError.invalid)
    }
}

