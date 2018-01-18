FROM anapsix/alpine-java:8

RUN mkdir /prometheus
ADD "https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/0.2.0/jmx_prometheus_httpserver-0.2.0-jar-with-dependencies.jar" /prometheus

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY jmx_cassandra.yml /prometheus

ENTRYPOINT ["/docker-entrypoint.sh"]
