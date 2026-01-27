ARG SDR_MONITOR_IMAGE="shajen/sdr-monitor:latest"
ARG SDR_SCANNER_IMAGE="shajen/sdr-scanner:latest"

FROM ${SDR_MONITOR_IMAGE} AS monitor
FROM ${SDR_SCANNER_IMAGE} AS scanner

FROM monitor

ENV TZ=UTC

ENV MQTT_URL=ws://127.0.0.1:9001/
ENV MQTT_USER=admin
ENV MQTT_PASSWORD=password
ENV MQTT_FRONTEND_PATH=/mqtt/

ENV HTTP_USER=admin
ENV HTTP_PASSWORD=password

ENV SECRET_KEY=

ENV DEBUG_SDR_SCANNER=0
ENV DJANGO_SERVER_WORKERS=1
ENV DJANGO_SERVER_THREADS=1
ENV LOG_DIR=/var/log/sdr/
ENV DUMP_SOURCE=false
ENV DUMP_RECORDING=false
ENV SOAPY_REMOTE=0

ENV DATABASE_ENGINE=mysql
ENV DATABASE_NAME=sdr
ENV DATABASE_USERNAME=sdr
ENV DATABASE_PASSWORD=sdr
ENV DATABASE_HOST=127.0.0.1
ENV DATABASE_PORT=3306

RUN apt-get update && \
    apt-get install -y --no-install-recommends gosu tzdata libspdlog1.12 libliquid1 nlohmann-json3-dev libpaho-mqtt1.3 libpaho-mqttpp3-1 libusb-1.0-0 libfftw3-bin && \
    apt-get install -y --no-install-recommends gnuradio libsoapysdr0.8 soapysdr0.8-module-all && \
    apt-get install -y --no-install-recommends supervisor mosquitto nginx logrotate htop nano && \
    apt-get install -y --no-install-recommends mysql-server && \
    apt-get purge -y soapysdr0.8-module-audio soapysdr0.8-module-uhd && \
    apt-get autoremove -y && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/ && \
    rm -rf /var/lib/mysql/* && \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx

COPY --from=scanner /sdr_scanner_* /
COPY --from=scanner /usr/bin/auto_sdr /usr/bin/auto_sdr
COPY --from=scanner /usr/bin/auto_sdr.debug /usr/bin/auto_sdr.debug
COPY --from=scanner /usr/local/bin/sdrplay_apiService /usr/local/bin/
COPY --from=scanner /usr/local/lib/libsdrplay_api.so* /usr/local/lib/
COPY --from=scanner /usr/local/lib/SoapySDR/modules0.8/libsdrPlaySupport.so /usr/local/lib/SoapySDR/modules0.8/

COPY config/supervisord.conf /etc/supervisor/supervisord.conf
COPY scripts/* /usr/local/bin/
COPY config/logrotate.conf /etc/logrotate.d/sdr.conf
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/mosquitto.conf /mosquitto/mosquitto.conf
COPY entrypoint/* /entrypoint/

RUN ldconfig && \
    mkdir -p /data && \
    mkdir -p /var/log/sdr && \
    rm /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf && \
    sed -i 's|.*datadir.*|datadir = /app/data/mysql|' /etc/mysql/mysql.conf.d/mysqld.cnf && \
    sed -i 's|.*log_error.*|log_error = /var/log/sdr/mysql.log|' /etc/mysql/mysql.conf.d/mysqld.cnf && \
    sed -i 's|.*binlog_expire_logs_seconds.*|disable_log_bin|' /etc/mysql/mysql.conf.d/mysqld.cnf

RUN mkdir -p /var/run/sdr && \
    chown -R ubuntu:ubuntu /etc/supervisor/ && \
    chown -R ubuntu:ubuntu /mosquitto/ && \
    chown -R ubuntu:ubuntu /var/lib/nginx/ && \
    chown -R ubuntu:ubuntu /var/log/sdr/ && \
    chown -R ubuntu:ubuntu /var/run/sdr/ && \
    chown -R ubuntu:ubuntu /var/lib/logrotate/ && \
    chown -R ubuntu:ubuntu /var/lib/mysql/ && \
    chown -R ubuntu:ubuntu /var/log/mysql/ && \
    chown -R ubuntu:ubuntu /var/run/mysqld/
ARG VERSION=""
ARG COMMIT=""
ARG CHANGES=""
RUN echo "$(TZ=UTC date +"%Y-%m-%dT%H:%M:%S%z")" | tee /sdr_hub_build_time && \
    echo "$VERSION" | tee /sdr_hub_version && \
    echo "$COMMIT" | tee /sdr_hub_commit && \
    echo "$CHANGES" | tee /sdr_hub_changes

WORKDIR /
EXPOSE 80
CMD ["/entrypoint/entrypoint.sh"]
