# ==================== 参数配置统一入口 ====================
DOCKER_TAG ?= dev_home:v1.0
BACKUP_DIR := /workspace/.home_backup

# ==================== 帮助信息 ====================
PROJECT_NAME := client
VERSION := 1.0
COLOR_RESET := \033[0m
COLOR_GREEN := \033[32m
COLOR_YELLOW := \033[33m
COLOR_BLUE := \033[34m
COLOR_RED := \033[31m
.PHONY: all
all: help
.PHONY: help
help: ## > 显示帮助信息
	@printf "$(COLOR_BLUE)================================================================$(COLOR_RESET)\n"
	@printf "$(COLOR_GREEN)  $(PROJECT_NAME):v$(VERSION) 项目管理工具! $(COLOR_RESET)\n"
	@printf "$(COLOR_BLUE)================================================================$(COLOR_RESET)\n"
	@printf "\n"
	@printf "$(COLOR_YELLOW)可用命令:$(COLOR_RESET)\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(COLOR_GREEN)%-20s$(COLOR_RESET) %s\n", $$1, $$2}'
	@printf "\n"
# ==================== 管理信息 ====================
.PHONY: build
build: ## > 重新创建镜像
	@printf "$(COLOR_BLUE)→ 重新创建镜像 $(COLOR_RESET)\n"
	docker build -t $(DOCKER_TAG) .
	@printf "$(COLOR_GREEN)✓ 重新创建镜像成功 $(COLOR_RESET)\n";

.PHONY: run	
run: ## > 重新创建容器
	@printf "$(COLOR_BLUE)→ 重新创建容器 $(COLOR_RESET)\n"
	@docker rm -f dev_home 2>/dev/null
	@docker run -it \
		--env-file ./envfile \
		--security-opt seccomp=unconfined \
		--shm-size=2gb \
		-v /workspace:/workspace \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v /run/user/1000/pulse/native:/tmp/pulse-socket \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v ~/.config/pulse/cookie:/tmp/pulse-cookie:ro \
		-v /run/user/1000/bus:/tmp/mybus  \
		--name dev_home \
		$(DOCKER_TAG) bash
	@printf "$(COLOR_GREEN)✓ 重新创建容器成功 $(COLOR_RESET)\n";

.PHONY: save
save: ## > 重新创建镜像
	@printf "$(COLOR_BLUE)→ 备份镜像 $(COLOR_RESET)\n"
	docker save $(DOCKER_TAG) -o $(BACKUP_DIR)/$(DOCKER_TAG).zip
	@printf "$(COLOR_GREEN)✓ 备份镜像成功 $(COLOR_RESET)\n";

.PHONY: load 
load: ## > 重新加载镜像
	@printf "$(COLOR_BLUE)→ 加载镜像 $(COLOR_RESET)\n"
	docker load -i $(BACKUP_DIR)/$(DOCKER_TAG).zip
	@printf "$(COLOR_GREEN)✓ 加载镜像成功 $(COLOR_RESET)\n";
