import CoreData

final class CoreDataStack {
    private let tag = "CoreDataStack"

    let container: NSPersistentContainer

    init() {
        let model = CoreDataModel.makeModel()
        container = NSPersistentContainer(name: "BookExplorerModel", managedObjectModel: model)

        container.loadPersistentStores { _, error in
            if let error {
                Log.e(self.tag, "CoreData load error: \(error)")
            } else {
                Log.d(self.tag, "CoreData loaded")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        let ctx = container.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return ctx
    }
}
