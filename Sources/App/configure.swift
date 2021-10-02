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
}
