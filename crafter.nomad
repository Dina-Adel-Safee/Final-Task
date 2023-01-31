job "crafter" {
  datacenters = ["dc1"]

  group "crafter" {
    count = 1

    network {
      port "elastic" {
        static = 9200
        to     = 9200
      }
      port "tomcat" {
        static = 8080
        to     = 8080
      }
      port "deployer" {
        static = 9191
        to     = 9191
      }
    }

    service {
      name = "CrafterCMS"
      port = "deployer"
    }
// ================== Elastic Search ==================================================
    task "elastic" {
      driver = "docker"

      config {
        image        = "docker.elastic.co/elasticsearch/elasticsearch:7.17.1"
        ports        = ["elastic"]
        hostname     = "elastic"
        network_mode = "nomad_net"
        volumes      = [
            "alloc/elasticsearch_data:/usr/share/elasticsearch/data",
            "alloc/elasticsearch_logs:/usr/share/elasticsearch/logs"
        ]
        labels {
            discovery_type        = "${env["discovery.type"]}"
            bootstrap_memory_lock = "${env["bootstrap.memory_lock"]}"
        }
        ulimit {
           memlock = "-1"
        }
      }
      env {
        discovery_type        = "single-node"
        bootstrap_memory_lock = "true"
        ES_JAVA_OPTS          = "-Xss1024K -Xmx1G"
      }
    }

// ====================== Tomcat ================================================
task "tomcat" {
      driver = "docker"

      config {
        image        = "craftercms/authoring_tomcat:4.0.2"
        ports        = ["tomcat"]
        hostname     = "tomcat"
        network_mode = "nomad_net"
        volumes      = [
          "alloc/crafter_data:/opt/crafter/data",
          "alloc/crafter_logs:/opt/crafter/logs",
          "alloc/crafter_temp:/opt/crafter/temp",
          "alloc/elasticsearch_data:/opt/crafter/data/indexes-es"
        ]
      }
      env {
      DEPLOYER_HOST  = "deployer"
      DEPLOYER_PORT  = "9191"
      ES_HOST        = "elastic"
      ES_PORT        = "elastic"
      }
     
    }

// ================= Crafter =========================================================
task "deployer" {
      driver = "docker"

      config {
        image        = "craftercms/deployer:4.0.2"
        ports        = ["deployer"]
        hostname     = "deployer"
        network_mode = "nomad_net"
        volumes      = [
          "alloc/crafter_data:/opt/crafter/data",
          "alloc/crafter_logs:/opt/crafter/logs",
          "alloc/crafter_temp:/opt/crafter/temp",
        ]
      }
      env {
          TOMCAT_HOST       = "tomcat"
          TOMCAT_HTTP_PORT  = "tomcat"
          ES_HOST           = "elastic"
          ES_PORT           = "elastic"
      }
    }
  }
}

