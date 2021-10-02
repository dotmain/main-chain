import Fluent
import FluentMongoDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    try app.databases.use(.mongo(
        connectionString: Environment.get("DATABASE_URL") ?? "mongodb://127.0.0.1:27017/institute"
    ), as: .mongo)

    try app.autoRevert().wait()
    app.migrations.add(CreateLicenseMigrator())
    app.migrations.add(CreateDataModelMigrator())
    app.migrations.add(CreateBlockModelMigrator())
    app.migrations.add(CreateBlockChainMigrator())
    
    try app.autoMigrate().wait()
    
    app.views.use(.leaf)
    try routes(app)
    
//    let data = DataModel(identifier: "SomeID", log: "Hello World", value: 100)
//    let _ = data.save(on: app.db)
//    let block = BlockModel(dataModels: [data])
//    block.add(datablock: data)
//    let _ = block.save(on: app.db)
//
//    let chain = BlockChain(genesis: block)
//    let next = chain.next(block: [data])
//    let _ = next.save(on: app.db)
//
//    print(chain.decoded)
    
    
//    print(chain.decoded)
}




//create genesis for license
//add blocks to unit
//calculuate license value
//store chain


//web routes
//api routes
//admin routes

//license admin
//value admin
//accounting
