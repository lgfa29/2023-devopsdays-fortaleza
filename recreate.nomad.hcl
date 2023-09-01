job "recreate" {
  group "server" {
    count = 3

    update {
      max_parallel = 3
    }

    network {
      port "http" {}
    }

    task "whoami" {
      driver = "docker"

      config {
        image = "traefik/whoami:v1.10"
        ports = ["http"]
      }

      env {
        WHOAMI_PORT_NUMBER = NOMAD_PORT_http
        WHOAMI_NAME        = "v2"
      }
    }
  }
}
