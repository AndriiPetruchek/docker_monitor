
Several prerequisites:

- cassandra container should participate jmx_monitor network in order to be reachable for JMX Exporter;
- docker network jmx_monitor should be created manually. There is a script start.sh which creates required 
  network and start "docker-compose up -d";
- Remote JMX without authentication should be enabled in cassandra. By default JMX enabled only from localhost
  Comment below line in order to enable JMX from remote hosts:
  #if [ "x$LOCAL_JMX" = "x" ]; then
  #    LOCAL_JMX=yes
  #fi
  Add this one:
  LOCAL_JMX=no
  and modify true -> flase in line:
  JVM_OPTS="$JVM_OPTS -Dcom.sun.management.jmxremote.authenticate=false"
- container with cassandra should has name "cassandra". Otherwise some re-configuration needed for JMX Exporter


How to start:

- specify ADMIN_USER and ADMIN_PASSWORD in the start.sh file. These credentials will be used to access all services:
  Grafana, Prometheus, Alertmanager
- execute the script


A little description:

JMX Exporter:

- docker container build from the source in order to minimize the image size;
- all collected metrics described in jmx_cassandra.yml file;
- Port, and config file location are described in docker-compose file. This will allow us use the same image to start another 
  JMX exporter container, for example for ElasticSearch monitoring;

Grafana:
- I modified docker-compose to use the latest grafana (4.6.3) instead of the initial (4.5.1);
- cassandra dashboard created;
- all dashboards are located in ./grafana/dashboards folder and mounted as volume;

Alerting:
Alerting consists of 2 parts: 
Prometeus alert.rule - which describes metrics and tresholds and Alertmanger - which describes notification ways and their configuration
Alertmanager:
- need to be configured once - will contain choosen configuration method

Prometheus ./prometheus/alerts.rule file:

- you need to add below line in order to create a new rule:

 - alert: cassandra_high_cpu					# alert name
    expr: cassandra_OS{name="ProcessCpuLoad"} * 100 > 50 	# alert expression
    for: 30s							# period of time after which rule will be considering as a "fired" 
								#if above expression is true
    labels:
      severity: warning 					# severity for the alert
    annotations:						# below lines will be added to the alert
      summary: "Cassandra high CPU usage" 
      description: "Cassandra CPU usage is {{ humanize $value}}%."
- once alert.rule file is modified according your needs, prometheus configuration need to be reload.
  This can be done without prometheus restart. You need to execute below command on the host where Prometheus docker is running:
  
  curl -u admin:admin -X POST http://localhost:9090/-/reload
  
  Where admin:admin username and password for admin user which you specified in start.sh script 
  Once configuration reloaded you can check alert status on the Alert page: http://localhost:9090/alerts

Consoles:

- Grafana http://localhost:3000
- Prometheus http://localhost:9090
- Alertmanager http://localhost:9093








