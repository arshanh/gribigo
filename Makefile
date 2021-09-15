
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

build:
	docker build -q . -t $(IMAGE_NAME);

test: build
	docker run $(IMAGE_NAME) go test -v -coverprofile=profile.cov ./..;

RTR_OPTS = -p $(GRIBI_PORT):$(GRIBI_PORT) \
			  -p $(GNMI_PORT):$(GNMI_PORT)

RTR_CMD =  rtr \
		-logtostderr \
		-cert $(RTR_CERT) \
		-key $(RTR_KEY) \
		-gribiaddr $(GRIBI_ADDR) \
		-gribiport $(GRIBI_PORT) \
		-gnmiaddr $(GNMI_ADDR) \
		-gnmiport $(GNMI_PORT)

rtr:
	docker run $(RTR_OPTS) $(IMAGE_NAME) $(RTR_CMD)
