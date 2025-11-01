import external.{type TypedSourceResource}
import resource.{type ArchiveResource, type TempResource}

pub type Config {
  Config(
    source: TypedSourceResource,
    temp: TempResource,
    archive: ArchiveResource,
  )
}
