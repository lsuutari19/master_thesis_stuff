provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
}

# Creating a Docker Container using the latest ubuntu image.
resource "docker_container" "webserver" {
  image             = docker_image.ubuntu.image_id
  name              = "terraform-docker-test"
  must_run          = true
  publish_all_ports = true
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "nginx-test"
  ports {
    internal = 80
    external = 8000
  }
}

resource "docker_volume" "shared_volume" {
  name = "shared_volume"
}
