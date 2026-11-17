variable "CACHE_REF" {}

group "default" {
  targets = ["app", "transcoder"]
}

target "docker-metadata-action" {}

target "app" {
  inherits = ["docker-metadata-action"]
  context    = "."
  dockerfile = "docker/prod/Dockerfile"
  target     = "app"
  tags       = [for tag in target.docker-metadata-action.tags : "${tag}-app"]
  cache-from = [
    "type=gha,scope=${CACHE_REF}-app",
    "type=registry,ref=${CACHE_REF}-app"
  ]
  cache-to = [
    "type=gha,mode=max,scope=${CACHE_REF}-app",
    "type=registry,ref=${CACHE_REF}-app,mode=max"
  ]
}

target "transcoder" {
  inherits = ["docker-metadata-action"]
  context    = "."
  dockerfile = "docker/prod/Dockerfile"
  target     = "transcoder"
  tags       = [for tag in target.docker-metadata-action.tags : "${tag}-transcoder"]
  cache-from = [
    "type=gha,scope=${CACHE_REF}-transcoder",
    "type=registry,ref=${CACHE_REF}-transcoder"
  ]
  cache-to = [
    "type=gha,mode=max,scope=${CACHE_REF}-transcoder",
    "type=registry,ref=${CACHE_REF}-transcoder,mode=max"
  ]
}
