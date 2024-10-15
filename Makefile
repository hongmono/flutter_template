# Makefile for managing versioning in a monorepo structure

# 타겟

# 도움말
help:
	@echo "사용 가능한 명령어:"
	@echo "  make help  - 도움말 표시"
	@echo "  make bump  - 선택한 프로젝트의 버전 증가"
	@echo "  make bs  - melos bootstrap"
	@echo "  make generate  - Code generate"


# 버전 증가
bump:
	@bash ./scripts/bump.sh

bs:
	@bash melos bs

generate:
	@bash ./scripts/generate.sh $(TARGET)

.PHONY: help bump bs generate