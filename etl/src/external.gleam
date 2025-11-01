import resource.{type SourceResource}

// For each external data feed, there must be an entry in Data, Schema, and TypedResource.
//
// The dataflow goes like this:
//
// 1. Download data from the TypedSourceResource into Data
// 2. Process the Data into a Schema
// 3. Load the data from the Schema into the Database
//
// Look at the `process()` function below, as that is the critical
// method in the dataflow.

// external json feed is consumed as data
pub type Data {
  // external json looks like this: {"a": 123}
  FooData(String)
  // external json looks like this: {"b": "abc"}
  BarData(String)
}

// data is parsed into a schema
pub type Schema {
  FooSchema(Int)
  BarSchema(String)
}

pub type TypedSourceResource {
  FooSourceResource(SourceResource)
  BarSourceResource(SourceResource)
}
