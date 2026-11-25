PROJECT_NAME := home_dev
VERSION := 1.0

# 颜色输出（终端美化）
COLOR_RESET := \033[0m
COLOR_GREEN := \033[32m
COLOR_YELLOW := \033[33m
COLOR_BLUE := \033[34m
COLOR_RED := \033[31m

# ==================== 默认目标 ====================
.PHONY: all
all: help

# ==================== 帮助信息 ====================
.PHONY: help
help: ## > 显示帮助信息
	@printf "$(COLOR_BLUE)================================================================$(COLOR_RESET)\n"
	@printf "$(COLOR_GREEN)  $(PROJECT_NAME):v$(VERSION) 项目管理工具! $(COLOR_RESET)\n"
	@printf "$(COLOR_GREEN)  tips: 推荐放置目录:/workspace/dev/home_dev $(COLOR_RESET)\n"
	@printf "$(COLOR_BLUE)================================================================$(COLOR_RESET)\n"
	@printf "\n"
	@printf "$(COLOR_YELLOW)可用命令:$(COLOR_RESET)\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(COLOR_GREEN)%-20s$(COLOR_RESET) %s\n", $$1, $$2}'
	@printf "\n"

# ==================== 管理信息 ====================
.PHONY: clean-push	
clean-push: ## > 纯净推送
	@printf "$(COLOR_BLUE)→ 纯净推送 $(COLOR_RESET)\n"
	git checkout --orphan tmp; \
		git rm -rf --cached .; \
		git add -A; \
		git commit -m "clean push"; \
		git branch -D main; \
		git branch -m main; \
		git push -f origin main; \
		git branch --set-upstream-to=origin/main main
	@printf "$(COLOR_GREEN)✓ 纯净推送成功 $(COLOR_RESET)\n";

.PHONY: backup 	
backup: ## > 执行备份
	@printf "$(COLOR_BLUE)→ 执行备份 $(COLOR_RESET)\n"
	$(MAKE) -C code_repo backup
	$(MAKE) -C client save
	@printf "$(COLOR_GREEN)✓ 执行备份成功 $(COLOR_RESET)\n";

.PHONY: restore
restore: ## > 执行恢复
	@printf "$(COLOR_BLUE)→ 执行恢复 $(COLOR_RESET)\n"
	$(MAKE) -C code_repo restore
	$(MAKE) -C client load
	@printf "$(COLOR_GREEN)✓ 执行恢复成功 $(COLOR_RESET)\n";








