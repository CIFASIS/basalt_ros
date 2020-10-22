help:
	@echo "help   -- print this help"
	@echo "shell  -- open shell in container"
	@echo "image  -- build Docker image"


image:
	docker build -t "basalt:ros_melodic" .
shell:
	docker run -it --net=host basalt:ros_melodic bash

.PHONY: help shell image

