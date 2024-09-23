# Database
The actual interface for interacting with the database we are using.
## Adapter
### Core functions
TBD
#### Sync Table Meta (sync_table_meta)
TBD
#### Sync Table (sync_table)
TBD
#### Sync Index (sync_index)
TBD
#### Read Table (read_table)
TBD
#### Update Table (update_table)
TBD
#### Insert Table (insert_table)
TBD
#### Delete Table (delete_table)
TBD
#### Read Filter (read_filter)
TBD
#### Prepare View (prepare_view)
TBD
#### Read View (read_view)
TBD
### Filters
TBD
# Query
## Read Single (read_single)
Executes the given query,
## Connection
# Schema
Different structures we use for defining the structure of our data within the database.
## Entity
TBD
## Link
TBD
## Index
TBD
## Entity View
Virtual table to view a subset of data from a specific entity and that entity's links.

Differs from a standard database view in that the fields of an entity view must ALWAYS be derived from its parent entity and its links.

Standard database views are currently not implemented.
# Database Drivers
## brsql
The Rust MySQL database driver
### [Adapter](#Adapter)
TBD
### [Query](#Query)
See [rust-g query execution code](https://github.com/tgstation/rust-g/blob/9682fc08fe0306247fabc303cc93dd9858f2ce76/src/sql.rs#L147-L226)

Query response JSON schema:
```json
{
	"$schema": "https://json-schema.org/draft/2020-12/schema",
	"title": "rust-g SQL Query Response",
	"description": "The JSON object returned from any rust-g query calls via the `rustg_sql_check_query()` proc.",
	"type": "object",
	"properties": {
		"status": {
			"type": "string"
		},
		"affected": {
			"type": "integer"
		},
		"last_insert_id": {
			"type": [ "integer", "null" ]
		},
		"columns": {
			"type": "array",
			"items": {
				"type": "object",
				"properties": {
					"name": {
						"type": "string"
					}
				}
			}
		},
		"rows": {
			"type": "array",
			"items": {
				"anyOf": [
					{
						"type": "number"
					},
					{
						"type": "string"
					},
					{
						"type": "null"
					},
					{
						"type": "array",
						"items": {
							"type": "number"
						}
					}
				]
			}
		}
	}
}
```
## Native
BYOND internal database driver: http://www.byond.com/docs/ref/#/database

Uses SQLite as its DB
> A /database datum gives you the ability to create or access a database using SQLite
