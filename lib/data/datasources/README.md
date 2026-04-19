### Enquiry about SQL & NoSQL (Isar)

Due to how different the backend and frontend is organized, there is some information needed to understand why and how the backend and frontend are different.

For one-to-one and one-to-many relation, in Isar, we use the foreign key provided by the backend database. In reality, it does not have any relation at all. Filtering in Isar is done through filtering through local database indexed id. It has no brain to process that table A and table B might be related. It is purely filtered through logic.

For many-to-many however, due to how complicated it is, we use IsarLinks. IsarLinks allow actual relational table mapping to be used. It avoids anti-pattern such as creating intermediary table, allowing backlinking, and it works well with updates. However this method is not preferred over embedding data as it not a NoSQL way. We are using this as opposed to embedding due to how the backend return json response while avoiding complex joins and broken json structure. 

For Many-To-Many that uses IsarLinks in this project, it is only found in [service](../models/isar/service) and [category](../models/isar/category).

# You should NOT process services before populating the category table!