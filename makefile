SRC_DIR := src
DEPLOYMENT_NAME=nodejs-deployment
ENVIRONMENT=dev
BASE_TAG=latest
KUBE_APP_IMAGE=harbor.monstar-lab.vn/demo/nodejs-app
KUBE_CLUSTER=--server=https://172.16.110.231:6443
APP_NAME=demo-nodejs

getcommit:
	cd $(SRC_DIR)
	GIT_COMMIT=$(shell git log -1 --pretty=format:%h)
kubeappimage:
	@echo ":::build app image"
	docker build --rm -f dockers/App.Dockerfile -t $(KUBE_APP_IMAGE):$(BASE_TAG) .
	docker push $(KUBE_APP_IMAGE)
	@echo ":::remove untagged images"
	docker images -f "dangling=true" -q | xargs -r docker rmi
kubebuildimage: kubeappimage
kubedeploy:
	@echo ":::build pod"
	 kubectl apply -f kubernetes/deployment.yaml
	 kubectl set image deployment/$(DEPLOYMENT_NAME) nodejs-container=harbor.monstar-lab.vn/demo/nodejs-app:"$(GIT_COMMIT)" -n demo-project
kubeservice:
	@echo ":::create service"
	 kubectl apply -f kubernetes/service.yaml
kubeimages: kubeappimage
kubeinit:  kubedeploy kubeservice
kuberollout:
	@echo "::: rollout"
	 kubectl rollout restart deployment/nodejs-app
kubeup: kubeappimage kubedeploy kubeservice
kubeupdate: kubeappimage kuberollout
kubedown:
	@echo ":::delete deployment"
	 kubectl delete secret $(APP_NAME)-secrets --ignore-not-found
	 kubectl delete deploy $(APP_NAME)-app-deployment --ignore-not-found
	 kubectl delete service $(APP_NAME)-service --ignore-not-found