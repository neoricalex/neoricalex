VERSION ?= focal-1.0.0-pre
ifdef BASE_IMAGE
	BUILD_ARG = --build-arg BASE_IMAGE=$(BASE_IMAGE)
	ifndef NAME
		NAME = neoricalex/nfdos-$(subst :,-,${BASE_IMAGE})
	endif
else
	NAME ?= neoricalex/nfdos
endif
ifdef TAG_ARCH
	# VERSION_ARG = $(VERSION)-$(subst /,-,$(subst :,-,${BASE_IMAGE}))-$(TAG_ARCH)
	VERSION_ARG = $(VERSION)-$(TAG_ARCH)
	LATEST_VERSION = latest-$(TAG_ARCH)
else
	# VERSION_ARG = $(VERSION)-$(subst /,-,$(subst :,-,${BASE_IMAGE}))
	VERSION_ARG = $(VERSION)
	LATEST_VERSION = latest
endif
VERSION_ARG ?= $(VERSION)

.PHONY: all vps

all: vps

vps:
	sudo reboot
	chmod +x iniciar_nfdos.sh
	./iniciar_nfdos.sh
	chmod +x iniciar_docker.sh 
	./iniciar_docker.sh 
	#docker build --no-cache -t $(NAME):$(VERSION_ARG) $(BUILD_ARG) --build-arg QEMU_ARCH=x86_64 --platform x86_64 --rm docker
