NS = alexisduque
RTONE = git.rtone.fr/sdr4iot
REPO = gpulab-tensorflow-sdr4iot
IMAGE = $(NS)/$(REPO)


.PHONY: build build_public push

build: build_public

build_public: Dockerfile
	@docker build -f Dockerfile -t $(IMAGE):latest .

push: build_public
	@docker push $(IMAGE):latest

default: build