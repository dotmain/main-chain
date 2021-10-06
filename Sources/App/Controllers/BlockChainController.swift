//
//  File.swift
//  
//
//  Created by Ω on 10/1/21.
//

import Fluent
import Vapor

//register chain for license
//get chain for license
//update chain withblocks
 
struct BlockChainController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let chain = routes.grouped("blockchain")
        chain.get(use: index)
        chain.post(use: create)
        chain.group(":identifier") { route in
            route.get(use: indexOne)
            route.post(use: add)
            route.delete(use: delete)
        }
        
        print("Router Set")
    }

    func index(req: Request) throws -> EventLoopFuture<[BlockChain]> {
        req.chain()
    }
    
    func indexOne(req: Request) throws -> EventLoopFuture<License> {
        try req.findLicense()
    }

    func create(req: Request) throws -> EventLoopFuture<Response> {
        try req.addLicense()
    }
    
    func add(req: Request) throws -> EventLoopFuture<Response> {
        try req.addToChain()
    }
    
    func delete(req: Request) throws -> EventLoopFuture<Response> {
        try req.deleteChain()
    }
}

extension Request {
    
    func filterChain() throws -> String {
        guard
            let license = parameters.get(BlockChainFields.identifier.rawValue.description)
        else { throw Abort(.internalServerError, reason: "Request unexpectedly missing identifier parameter") }
        return license
    }

    func chain() -> EventLoopFuture<[BlockChain]> {
        BlockChain
            .query(on: db)
            .all()

    }

    func findChain() throws -> EventLoopFuture<BlockChain> {
        let identifier = try filterChain()
        return try findChain(identifier: identifier)
    }
    
    func findChain(identifier: String) throws -> EventLoopFuture<BlockChain> {
        return BlockChain
            .query(on: db)
            .filter(\.$identifier == identifier)
            .first()
            .unwrap(or: Abort(.notFound, reason: "No license with matching id"))
    }

    func addChain(identifier: String) throws -> EventLoopFuture<Response> {
        return try findChain(identifier: identifier)
            .flatMapAlways { result in
                switch result {
                case .success:
                    return self.eventLoop.makeSucceededFuture(Response(status: .ok))
                case .failure:
                    let genesis = DataModel(identifier: identifier,
                                            version: BlockChainFields.genesis.rawValue.description,
                                            model: BlockChainFields.genesis.rawValue.description,
                                            log: BlockChainFields.genesis.rawValue.description + "-" + identifier,
                                            value: 0.0)
                    return genesis.save(on: self.db)
                        .flatMap{ _ in
                            let block = BlockModel(identifier: identifier, dataModels: [genesis])
                            return block.save(on: self.db)
                                .flatMap { _ in
                                    let chain = BlockChain(genesis: block)
                                    return chain.save(on: self.db)
                                        .map { _ in Response(status: .ok) }
                                }.flatMapErrorThrowing { error in
                                    throw Abort(.conflict, reason: "A chain with identifier exists: \(error)")
                                }
                        }.flatMapErrorThrowing { error in
                            throw Abort(.conflict, reason: "A block with identifier exists: \(error)")
                        }
                }
            }
    }
//
    func addToChain() throws -> EventLoopFuture<Response> {
        let identifier = try filterChain()
        let newLog = try content.decode(DataLog.self)
        return try findChain()
            .tryFlatMap({ chain in
                let model = DataModel(identifier: identifier,
                                      version: newLog.version,
                                      model: newLog.model,
                                      log: newLog.log,
                                      value: newLog.value)
                return model.save(on: self.db)
                    .flatMap{ _ in
                        let block = chain.next(block: BlockModel(identifier: model.identifier, dataModels: [model]))
                        return block.save(on: self.db)
                            .tryFlatMap { _ in
                                var blcks = chain.blocks
                                blcks.append(block)
                                return BlockChain
                                    .query(on: self.db)
                                    .set(\.$blocks, to: blcks)
                                    .filter(\.$identifier == identifier)
                                    .update()
                                    .map { _ in Response(status: .ok,
                                                         body: .init(string: "\(identifier) updated")) }
                            }
                    }.flatMapErrorThrowing{ error in
                        throw Abort(.conflict, reason: "Coudnl't find chains: \(error)")
                    }
            }).flatMapErrorThrowing{ error in
                throw Abort(.conflict, reason: "Coudnl't find chains: \(error)")
            }
        
    }
//
    func deleteChain() throws -> EventLoopFuture<Response> {
        let identifier = try filterChain()
        return BlockChain
            .query(on: db)
            .filter(\.$identifier == identifier)
            .delete()
            .map { _ in Response(status: .ok,
                                 body: .init(string: "\(identifier) deleted")) }
    }
}
