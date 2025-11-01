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

pub type TempResource {
  TempResource(Resource)
}

pub type ArchiveResource {
  ArchiveResource(Resource)
}

pub type SourceResource {
  FooSourceResource(Resource)
  BarSourceResource(Resource)
}

pub type Resource {
  ResourceUrl(Url)
  ResourceLocalFile(LocalFilePath)
  ResourceRemoteFile(RemoteFilePath, config: SSHConfig)
  ResourceS3(bucket: S3Bucket, object: S3Object, config: S3Config)
}
