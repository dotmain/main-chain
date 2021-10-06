//
//  DataBlock.swift
//  
//
//  Created by m4m4 on 24.06.21.
//

import Foundation
import Fluent
import Vapor

enum DataModelFields: FieldKey {
    case schema = "data"
    case id
    case identifier
    case version
    case log
    case value
    case synthesis
    case total
    case createdAt
}

struct DataLog: Content {
    var log: String
    var value: Double
    var identifier: String
    var version: String
}

final class DataModel: Model, Content {
    static let schema = DataModelFields.schema.rawValue.description
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: DataModelFields.identifier.rawValue) //model uuid
    var identifier: String
    
    @Field(key: DataModelFields.log.rawValue)
    var log: String
    
    @Field(key: DataModelFields.version.rawValue)
    var version: String
    
    @Field(key: DataModelFields.value.rawValue)
    var value: Double
    
    @Field(key: DataModelFields.total.rawValue)
    var total: Double
    
    @Field(key: DataModelFields.synthesis.rawValue)
    var synthesis: Double

    @Timestamp(key: DataModelFields.createdAt.rawValue, on: .create)
    var createdAt: Date?

    private(set) var processors: Processor = DataProcess()
  
    private enum CodingKeys: CodingKey {
        case id
        case identifier
        case version
        case log
        case value
        case createdAt
    }
   
    init() { }

    init(id: UUID? = nil,
         createdAt: Date? = nil,
         identifier: String,
         version: String,
         log: String,
         value: Double
    ) {
        self.id = id
        self.log = log
        self.identifier = identifier
        self.version = version
        self.createdAt = createdAt
        var logValue = value
        processors.apply(to: &logValue)
        self.total = logValue
        self.value = value
        self.synthesis = logValue - value
    }
}
