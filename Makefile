IMAGE=arkaitzj/bk-handler

build:
	docker build -t ${IMAGE} .

upload: build
	docker push ${IMAGE}

