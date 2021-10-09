//
//  CreateLicensor.swift
//  
//
//  Created by Ω on 10/1/21.
//

import Fluent

struct CreateLicenseMigrator: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        print("MIGRATION License")
        return database.schema(LicenseFields.schema.rawValue.description)
            .id()
            .field(LicenseFields.type.rawValue, .string, .required)
            .field(LicenseFields.name.rawValue, .string, .required)
            .field(LicenseFields.identifier.rawValue, .string, .required)
            .field(LicenseFields.model.rawValue, .string, .required)
            .field(LicenseFields.valid.rawValue, .bool, .required)
            .field(LicenseFields.createdAt.rawValue, .datetime)
            .field(LicenseFields.lastUpdateTime.rawValue, .datetime)
            .unique(on: LicenseFields.identifier.rawValue)
            .unique(on: LicenseFields.id.rawValue)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(LicenseFields.schema.rawValue.description).delete()
    }
}
