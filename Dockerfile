FROM registry.access.redhat.com/ubi8/ubi:8.3-227

RUN dnf -y --disableplugin=subscription-manager module enable ruby:2.6 && \
    dnf -y --disableplugin=subscription-manager --setopt=tsflags=nodocs install \
      ruby-devel \
      # To compile native gem extensions
      gcc-c++ make redhat-rpm-config \
      # For git based gems
      git \
      # For checking service status
      nmap-ncat \
      # Libraries
      postgresql-devel openssl-devel libxml2-devel \
      # For the rdkafka gem
      cyrus-sasl-devel zlib-devel openssl-devel diffutils \
      # For the mimemagic gem (+rails)
      shared-mime-info \
      && \
    dnf --disableplugin=subscription-manager clean all

ENV WORKDIR /opt/topological_inventory-api/
ENV RAILS_ROOT $WORKDIR
WORKDIR $WORKDIR

COPY docker-assets/librdkafka-1.5.0.tar.gz /tmp/librdkafka.tar.gz
RUN cd /tmp && tar -xf /tmp/librdkafka.tar.gz && cd librdkafka-1.5.0 && \
    ./configure --prefix=/usr && \
    make -j2 && make install && \
    rm -rf /tmp/librdkafka*

COPY Gemfile $WORKDIR
RUN echo "gem: --no-document" > ~/.gemrc && \
    gem install bundler --conservative --without development:test && \
    bundle install --jobs 8 --retry 3 && \
    rm -rvf $(gem env gemdir)/cache/* && \
    rm -rvf /root/.bundle/cache

COPY . $WORKDIR
COPY docker-assets/entrypoint /usr/bin
COPY docker-assets/run_rails_server /usr/bin

RUN chgrp -R 0 $WORKDIR && \
    chmod -R g=u $WORKDIR

EXPOSE 3000

RUN chgrp -R 0 $WORKDIR && \
    chmod -R g=u $WORKDIR && \
    curl -L -o /usr/bin/haberdasher \
    https://github.com/RedHatInsights/haberdasher/releases/latest/download/haberdasher_linux_amd64 && \
    chmod 755 /usr/bin/haberdasher

ENTRYPOINT ["/usr/bin/haberdasher"]
CMD ["entrypoint", "run_rails_server"]
