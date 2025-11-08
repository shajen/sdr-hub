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

RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata libspdlog1.12 libliquid1 nlohmann-json3-dev libpaho-mqtt1.3 libpaho-mqttpp3-1 libusb-1.0-0 libfftw3-bin && \
    apt-get install -y --no-install-recommends gnuradio libsoapysdr0.8 soapysdr0.8-module-all && \
    apt-get install -y --no-install-recommends supervisor mosquitto nginx logrotate htop nano && \
    apt-get purge -y soapysdr0.8-module-audio soapysdr0.8-module-uhd && \
    apt-get autoremove -y && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/

COPY --from=scanner /sdr_scanner_* /
COPY --from=scanner /usr/bin/auto_sdr /usr/bin/auto_sdr
COPY --from=scanner /usr/bin/auto_sdr.debug /usr/bin/auto_sdr.debug
COPY --from=scanner /usr/local/bin/sdrplay_apiService /usr/local/bin/
COPY --from=scanner /usr/local/lib/libsdrplay_api.so* /usr/local/lib/
COPY --from=scanner /usr/local/lib/SoapySDR/modules0.8/libsdrPlaySupport.so /usr/local/lib/SoapySDR/modules0.8/

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY scripts/* /usr/local/bin/
COPY config/logrotate.conf /etc/logrotate.d/sdr.conf
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/mosquitto.conf /mosquitto/mosquitto.conf
COPY entrypoint/* /entrypoint/

RUN ldconfig && \
    mkdir -p /data && \
    mkdir -p /var/log/sdr && \
    rm /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf
RUN mkdir -p /var/run/sdr && \
    chown -R ubuntu:ubuntu /etc/supervisor/conf.d/ && \
    chown -R ubuntu:ubuntu /mosquitto/ && \
    chown -R ubuntu:ubuntu /var/lib/nginx/ && \
    chown -R ubuntu:ubuntu /var/log/sdr/ && \
    chown -R ubuntu:ubuntu /var/run/sdr/
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
