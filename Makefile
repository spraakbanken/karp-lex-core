
.default: help

.PHONY: help
help:
	@echo "usage:"
	@echo "dev | install-dev"
	@echo "   setup development environment"
	@echo ""
	@echo "test | run-all-tests"
	@echo "   run all tests"
	@echo ""
	@echo "run-doc-tests"
	@echo "   run all tests"
	@echo ""
	@echo "run-all-tests-w-coverage"
	@echo "   run all tests with coverage collection"
	@echo ""
	@echo "lint"
	@echo "   lint the code"
	@echo ""
	@echo "type-check"
	@echo "   check types"
	@echo ""
	@echo "fmt"
	@echo "   run formatter on all code"
	@echo ""
	@echo "fmt-check"
	@echo "   check formatting on all code"
	@echo ""
	@echo "publish"
	@echo "   publish tagged commit code to PyPI"
	@echo ""
	@echo "build"
	@echo "   build distribution"

PLATFORM := ${shell uname -o}
PROJECT := karp-lex_core
PROJECT_SRC := src/karp/lex_core

default_cov := "--cov=src/karp"
cov_report := "term-missing"
cov := ${default_cov}

ifeq (${VIRTUAL_ENV},)
  VENV_NAME = .venv
  INVENV = poetry run
else
  VENV_NAME = ${VIRTUAL_ENV}
  INVENV =
endif

${info Platform: ${PLATFORM}}

dev: install-dev
install-dev:
	poetry install

.PHONY: test
test: run-all-tests
.PHONY: run-all-tests
run-all-tests:
	${INVENV} pytest -vv tests

.PHONY: doc-tests
doc-tests:
	${INVENV} pytest --doctest-modules ${PROJECT_SRC}

.PHONY: doc-tests-w-coverage
doc-tests-w-coverage:
	${INVENV} pytest ${cov} --cov-report=${cov_report} --doctest-modules ${PROJECT_SRC}

.PHONY: test-w-coverage
test-w-coverage:
	${INVENV} pytest -vv ${cov}  --cov-report=${cov_report} tests

.PHONY: type-check
type-check:
	${INVENV} mypy -p karp.lex_core

.PHONY: lint
lint:
	${INVENV} ruff ${PROJECT_SRC} tests

part := "patch"
# bump given part of version
bumpversion:
	${INVENV} bump2version ${part}

.PHONY: fmt
fmt:
	${INVENV} ruff format ${PROJECT_SRC} tests

.PHONY: fmt-check
.PHONY: check-fmt
fmt-check: check-fmt
check-fmt:
	${INVENV} ruff format --check ${PROJECT_SRC} tests

.PHONY: publish
publish:
	git push origin main --tags

.PHONY: build
build:
	poetry build
