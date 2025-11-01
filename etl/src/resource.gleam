// ------------------------------------------------------------------
// simple types
// ------------------------------------------------------------------
pub type SSHConfig {
  SSHConfig(String)
}

pub type S3Config {
  S3Config(String)
}

pub type S3Bucket {
  S3Bucket(String)
}

pub type S3Object {
  S3Object(String)
}

pub type Url {
  Url(String)
}

pub type RemoteFilePath {
  RemoteFilePath(String)
}

pub type LocalFilePath {
  LocalFilePath(String)
}

pub type SourceResource {
  SourceResource(Resource)
}

pub type TempResource {
  TempResource(Resource)
}

pub type ArchiveResource {
  ArchiveResource(Resource)
}

// ------------------------------------------------------------------
// opaque type(s)
// ------------------------------------------------------------------
pub opaque type Resource {
  ResourceUrl(Url)
  ResourceLocalFile(LocalFilePath)
  ResourceRemoteFile(RemoteFilePath, config: SSHConfig)
  ResourceS3(bucket: S3Bucket, object: S3Object, config: S3Config)
}

// ------------------------------------------------------------------
// opaque type(s) constructors
// ------------------------------------------------------------------
pub fn new_url_resource(url: String) -> Result(Resource, Nil) {
  // TODO: validate url
  Ok(ResourceUrl(Url(url)))
}

pub fn new_local_file_resource(path: String) -> Result(Resource, Nil) {
  // TODO : validate local file resource exists
  Ok(ResourceLocalFile(LocalFilePath(path)))
}

pub fn new_remote_file_resource(
  path: String,
  config: SSHConfig,
) -> Result(Resource, Nil) {
  // TODO : validate remote file exists (and we have permissions to read it)
  Ok(ResourceRemoteFile(RemoteFilePath(path), config))
}

pub fn new_s3_resource(
  bucket: S3Bucket,
  object: S3Object,
  config: S3Config,
) -> Result(Resource, Nil) {
  // TODO : validate remote bucket & object exists (and we have permissions to read it)
  Ok(ResourceS3(bucket, object, config))
}
