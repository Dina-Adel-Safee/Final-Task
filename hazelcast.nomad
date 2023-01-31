job "hazelcast" {
  datacenters = ["dc1"]
  type = "service"
  group "hazelcast" {
    count = 3

    network {
      port "hazelcast" {
        to     = 5701
      }
    }
    service {
      name = "hazelcast"
      port = "hazelcast"
    }

    task "keycloak" {
      driver = "docker"
      config {
        image        = "hazelcast/hazelcast:5.2.1"
        ports        = ["hazelcast"]
        network_mode = "nomad_net"
        hostname     = "hazelcast"
       }
    } 
  }
}



