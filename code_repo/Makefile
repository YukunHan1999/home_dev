# ==================== 帮助信息 ====================
DOCKER_TAG ?= gogs/gogs
BACKUP_DIR := /workspace/.home_backup

# ==================== 帮助信息 ====================
PROJECT_NAME := code_repo
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
.PHONY: run 
run: ## > 重新创建容器
	@printf "$(COLOR_BLUE)→ 重新创建容器 $(COLOR_RESET)\n"
	@docker rm -f hyk.com 2>/dev/null
	@docker run -d \
		--env-file ./envfile \
		--name hyk.com \
		-v ${PWD}/workspace:/data \
		${DOCKER_TAG}
	@printf "$(COLOR_GREEN)✓ 重新创建容器成功 $(COLOR_RESET)\n";

.PHONY: backup 
backup: # 备份代码仓库
	@printf "$(COLOR_BLUE)→ 备份代码仓库 $(COLOR_RESET)\n"
	@sudo tar -zcv -f workspace.tar.gz ./workspace/
	@mkdir -p $(BACKUP_DIR)
	@mv workspace.tar.gz $(BACKUP_DIR)
	@printf "$(COLOR_GREEN)✓ 备份代码仓库成功 $(COLOR_RESET)\n";

.PHONY: restore
restore: # 从压缩仓库中恢复
	@printf "$(COLOR_BLUE)→ 从压缩仓库中恢复 $(COLOR_RESET)\n"
	@tar -zxvf $(BACKUP_DIR)/workspace.tar.gz -C ./
	@printf "$(COLOR_GREEN)✓ 从压缩仓库中恢复成功 $(COLOR_RESET)\n";
