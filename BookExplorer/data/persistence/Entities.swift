import CoreData

@objc(BookCacheEntity)
final class BookCacheEntity: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var authors: [String]
    @NSManaged var firstPublishYear: Int32
    @NSManaged var coverId: Int32
    @NSManaged var bookDescription: String?
    @NSManaged var updatedAt: Date
    @NSManaged var kind: String
}
