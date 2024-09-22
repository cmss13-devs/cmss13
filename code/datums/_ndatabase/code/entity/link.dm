// MIT License

// Copyright (c) 2020 Neth Iafin

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

/// Datum to represent a relation between two entities in the DB.
/// Should not have any child types, all entity links should be queued for creation by
/// overriding the `get_entity_links` proc.
/datum/entity_link
	/// Entity that is being referenced
	var/parent_entity
	/// Entity that is referencing a different entity
	var/child_entity
	/// Column on child entity to reference parent entity.
	/// A typepath to the db_field datum that represents the column
	var/child_foreign_key

	var/datum/entity_meta/parent_meta
	var/datum/entity_meta/child_meta

	var/enforced = FALSE

	var/list/child_requests

/datum/entity_link/New(parent_entity, child_entity, child_foreign_key)
	src.parent_entity = parent_entity
	src.child_entity = child_entity
	src.child_foreign_key = child_foreign_key

/datum/entity_link/proc/get_filter(parent_alias, child_alias)
	return new /datum/db/filter/link(parent_alias, DB_DEFAULT_ID_FIELD, child_alias, child_foreign_key)
