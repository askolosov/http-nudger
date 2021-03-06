resource "aiven_kafka" "http-nudger" {
  project      = data.aiven_project.http-nudger.project
  cloud_name   = var.aiven_cloud_name
  plan         = var.aiven_kafka_plan
  service_name = "http-nudger-kafka"
  kafka_user_config {
    kafka_authentication_methods {
      certificate = true
      sasl        = false
    }
  }
}

resource "aiven_kafka_topic" "url-monitor-prod" {
  project      = data.aiven_project.http-nudger.project
  service_name = aiven_kafka.http-nudger.service_name
  topic_name   = "url-monitor-prod"
  partitions   = 3
  replication  = 2
}

resource "aiven_kafka_topic" "url-monitor-test" {
  project      = data.aiven_project.http-nudger.project
  service_name = aiven_kafka.http-nudger.service_name
  topic_name   = "url-monitor-test"
  partitions   = 1
  replication  = 2
}

output "kafka" {
  sensitive = true
  value = {
    "bootstrap_servers" = aiven_kafka.http-nudger.service_uri
    "topic_name"        = aiven_kafka_topic.url-monitor-prod.topic_name
    "test_topic_name"   = aiven_kafka_topic.url-monitor-test.topic_name
    "access_key"        = aiven_kafka.http-nudger.kafka[0].access_key
    "access_cert"       = aiven_kafka.http-nudger.kafka[0].access_cert
  }
}
