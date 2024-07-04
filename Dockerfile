FROM quay.io/keycloak/keycloak:25.0.1 as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
# Configure a cache provider
ENV KC_CACHE=ispn
ENV KC_CACHE_STACK=kubernetes

# Configure a database vendor
ENV KC_DB=postgres

# configure features
ENV KC_FEATURES="docker,scripts"

# TODO: Add your custom theme here

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:25.0.1
COPY --from=builder /opt/keycloak/ /opt/keycloak/

EXPOSE 8443
EXPOSE 8080


ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]