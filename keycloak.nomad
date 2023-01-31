job "keycloak" {
  datacenters = ["dc1"]
  type = "service"
  group "keycloak" {
    count = 1

    network {
      port "keycloak" {
        static = 8080        
        to     = 8080
      }
    }
    service {
      name = "keycloak"
      port = "keycloak"
    }

    task "keycloak" {
      driver = "docker"
      config {
        image        = "quay.io/keycloak/keycloak:17.0.1"
        ports        = ["keycloak"]
        hostname     = "keycloak"
        network_mode = "nomad_net"
        args         = [
          "--verbose",
          "start-dev",
          "--db postgres",
          "--db-username postgres",
          "--db-password keycloak",
          "--db-url-host 172.26.0.2"
				]
        volumes = ["nomad/_data/keycloak/providers:/opt/keycloak/providers"]
       }
      
      env {
        KEYCLOAK_ADMIN          = "admin" 
        KEYCLOAK_ADMIN_PASSWORD = "admin"
       }

      resources {
        cpu    = 1000
        memory = 1024
     }
    } 
  }
}


