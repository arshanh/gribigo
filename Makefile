# Using makefile because ADS doesn't support docker-compose

IMAGE_NAME = gribigo
PWD := $(shell pwd)

GRIBI_PORT = 57333

GRIBI_PORT = 57333
GRIBI_ADDR = 0.0.0.0
GNMI_PORT = 57334
GNMI_ADDR = 0.0.0.0

RTR_CERT = testcommon/testdata/server.cert
RTR_KEY = testcommon/testdata/server.key

.PHONY: test, rtr

# So that this works on RHEL which doesn't have docker
RC=$(shell which podman 1> /dev/null; echo $$?)
ifeq ($(RC), 0)
	DOCKER_RUN=podman run
	DOCKER_BUILD=buildah build-using-dockerfile
else
	DOCKER_RUN=docker run
	DOCKER_BUILD=docker build
endif

build:
	$(DOCKER_BUILD) -t $(IMAGE_NAME) .;

test: build
	$(DOCKER_RUN) $(IMAGE_NAME) go test -v -coverprofile=profile.cov ./..;

RTR_OPTS = --publish $(GRIBI_PORT):$(GRIBI_PORT) \
			  --publish $(GNMI_PORT):$(GNMI_PORT)

RTR_CMD =  rtr \
		-logtostderr \
		-v 10 \
		-cert $(RTR_CERT) \
		-key $(RTR_KEY) \
		-gribiaddr $(GRIBI_ADDR) \
		-gribiport $(GRIBI_PORT) \
		-gnmiaddr $(GNMI_ADDR) \
		-gnmiport $(GNMI_PORT)

rtr:
	$(DOCKER_RUN) $(RTR_OPTS) $(IMAGE_NAME) $(RTR_CMD)

compliance:
	$(DOCKER_RUN) $(RTR_OPTS) $(IMAGE_NAME) $(RTR_CMD)
