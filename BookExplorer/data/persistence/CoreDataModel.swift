import CoreData

enum CoreDataModel {
    static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // BookCacheEntity
        let book = NSEntityDescription()
        book.name = "BookCacheEntity"
        book.managedObjectClassName = NSStringFromClass(BookCacheEntity.self)

        let id = NSAttributeDescription()
        id.name = "id"
        id.attributeType = .stringAttributeType
        id.isOptional = false

        let title = NSAttributeDescription()
        title.name = "title"
        title.attributeType = .stringAttributeType
        title.isOptional = false

        let authors = NSAttributeDescription()
        authors.name = "authors"
        authors.attributeType = .transformableAttributeType
        authors.valueTransformerName = NSValueTransformerName.secureUnarchiveFromDataTransformerName.rawValue
        authors.isOptional = false

        let year = NSAttributeDescription()
        year.name = "firstPublishYear"
        year.attributeType = .integer32AttributeType
        year.isOptional = true

        let coverId = NSAttributeDescription()
        coverId.name = "coverId"
        coverId.attributeType = .integer32AttributeType
        coverId.isOptional = true

        let desc = NSAttributeDescription()
        desc.name = "bookDescription"
        desc.attributeType = .stringAttributeType
        desc.isOptional = true

        let updatedAt = NSAttributeDescription()
        updatedAt.name = "updatedAt"
        updatedAt.attributeType = .dateAttributeType
        updatedAt.isOptional = false

        let kind = NSAttributeDescription()
        kind.name = "kind"
        kind.attributeType = .stringAttributeType
        kind.isOptional = false
        // kind = "feed" or "details"

        book.properties = [id, title, authors, year, coverId, desc, updatedAt, kind]
        model.entities = [book]
        return model
    }
}
