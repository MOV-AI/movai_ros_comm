REGISTRY="registry.cloud.mov.ai"
ENV="qa"
IMAGE_NAME="flow-initiator-noetic"
IMAGE_TAG="local"
DOCKER_IMAGE="registry.cloud.mov.ai/qa/ros-buildtools-noetic:v2.1.1"


deb:
	DOCKER_IMAGE="registry.cloud.mov.ai/qa/ros-buildtools-noetic:v2.1.1"; \
	container_id=$$(docker run -td -v "$$(pwd)":/src "$$DOCKER_IMAGE" sh) && \
	echo "Running in $$container_id" && \
	docker exec -t -uroot "$$container_id" bash -c " \
    sudo apt update ; \
    sudo apt install -y mobros=2.1.1.5 ; \
    mkdir /opt/mov.ai/user/cache/ros/src/ ; \
    ln -s /src /opt/mov.ai/user/cache/ros/src/ ; \
    mobros raise --workspace=/src ; \
    sudo mobros install-build-dependencies --workspace="/src" ; \
    mobros build --mode release ; \
    export MOVAI_OUTPUT_DIR="$(pwd)/artifacts" ; \
    mobros pack --workspace="/src" --mode release \
    " || true; \
	docker rm -f "$$container_id"
