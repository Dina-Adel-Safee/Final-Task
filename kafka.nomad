job "kafka" {
  datacenters = ["dc1"]
  type = "service"
  
group "kafka-g" {
    count = 1
    network {
      port "broker" {
        static = 9092
        to     = 9092
      }
    }
    service {
      name = "kafka-srv"
      port = "broker"
    }

    task "kc" {
      driver = "docker"
      config {
        image        = "ubuntu/kafka:3.1-22.04_beta"
        ports        = ["broker"]
        hostname     = "kafka-h"
        network_mode = "nomad_net"
        extra_hosts  = ["zookeeper:172.26.0.2"]
        volumes      = ["local/data:/var/lib/kafka/data"]
      }
      
      env {
         TZ             = "UTC"
         ZOOKEEPER_HOST = "zookeeper"
      }
    }   
  }

}
