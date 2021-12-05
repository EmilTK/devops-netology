FROM centos:7
Label maintainer="emiltk92@gmail.com"
EXPOSE 9200 9300
RUN yum -y update && yum clean all && yum install -y wget perl-Digest-SHA
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-linux-x86_64.tar.gz && \
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-linux-x86_64.tar.gz.sha512 && \
shasum -a 512 -c elasticsearch-7.15.2-linux-x86_64.tar.gz.sha512 && \
tar -xzf elasticsearch-7.15.2-linux-x86_64.tar.gz && \
rm elasticsearch-7.15.2-linux-x86_64.tar.gz elasticsearch-7.15.2-linux-x86_64.tar.gz.sha512
COPY elasticsearch.yml elasticsearch-7.15.2/config/elasticsearch.yml
RUN groupadd elasticsearch && useradd -m -g elasticsearch -s /bin/bash elasticsearch && \
chown -R elasticsearch:elasticsearch elasticsearch-7.15.2 && \
mkdir -p /var/lib/elasticsearch/{snapshots,data} && \
chown -R elasticsearch:elasticsearch /var/lib/elasticsearch && \
mkdir -p /var/log/elasticsearch
USER elasticsearch
WORKDIR elasticsearch-7.15.2
CMD ["./bin/elasticsearch"]
