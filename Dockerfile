FROM ubuntu:24.04 AS provider-builder
RUN apt-get update && apt-get install -y zip
COPY ./providers /providers
RUN /providers/build.sh

FROM quay.io/keycloak/keycloak:26.2.4 AS builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
# Configure a cache provider (not used for building but default for runtime!)
ENV KC_CACHE=ispn
ENV KC_CACHE_STACK=kubernetes

# Configure a database vendor
ENV KC_DB=postgres

# configure features
ENV KC_FEATURES="docker,scripts"

# add providers
COPY --from=provider-builder ./output /opt/keycloak/providers

# TODO: Add your custom theme here

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.2.4
COPY --from=builder /opt/keycloak/ /opt/keycloak/

EXPOSE 8443
EXPOSE 8080


ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]