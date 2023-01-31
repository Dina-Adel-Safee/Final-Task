job "zookeeper" {
  datacenters = ["dc1"]
  type = "service"
  group "zookeeper-g" {
    count = 1

    network {
      port "zookeeper-port" {
        static = 2181
        to     = 2181
      }
    }

    service {
      name = "zookeeper-srv"
      port = "zookeeper-port"
    }

    task "zc" {
      driver = "docker"
      config {
        image        = "ubuntu/zookeeper:edge"
        ports        = ["zookeeper-port"]
        hostname     = "zookeeper-h"
        network_mode = "nomad_net"
      }
      env {
        TZ = "UTC"
      }
    }
  }

}
