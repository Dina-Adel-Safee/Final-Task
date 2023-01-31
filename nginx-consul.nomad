job "nginx" {
  datacenters = ["dc1"]

  group "nginx" {
    count = 1

    network {
      port "http" {
        static = 8888
        to     = 8082
      }
    }

    service {
      name = "nginx"
      port = "http"
    }

    task "nginx" {
      driver = "docker"

      config {
        image   = "nginx"
        ports   = ["http"]
        volumes = [
          "local/nginx-consul.conf:/etc/nginx/conf.d/nginx-consul.conf",
          "nomad/_data/Nginx:/home/nginx-page"
        ]
      }

      template {
        data        = "{{ key \"nginx\" }}"
        destination = "local/nginx-consul.conf"
      }
    }
  }
}
