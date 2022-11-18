ifndef VERBOSE
MAKEFLAGS += --silent
endif

db       ?= db_local
file     ?=
pw       ?= mysqlrootpassword
tag      ?= latest
work_dir := $(shell pwd)

.PHONY: check
check:
	docker exec mysql-check-ddl-$(db) sh -c \
		"mysql -u root --password=$(pw) --database=$(db) < /tmp/files/$(file)"

.PHONY: createdb
createdb:
	docker exec mysql-check-ddl-$(db) sh -c \
		"echo \"CREATE SCHEMA IF NOT EXISTS $(db) \
			DEFAULT CHARACTER SET utf8mb4 \
			COLLATE utf8mb4_bin\" \
		| mysql -u root --password=$(pw)"

.PHONY: down
down:
	docker stop mysql-check-ddl-$(db)

.PHONY: ping
ping:
	docker exec mysql-check-ddl-$(db) sh -c \
		"echo \"SHOW databases\" \
		| mysql -u root --password=$(pw)"

.PHONY: pull
pull:
	docker pull mysql:$(tag)

.PHONY: run
run:
	docker run --rm \
		--name mysql-check-ddl-$(db) \
		-e MYSQL_ROOT_PASSWORD=$(pw) \
		-v $(work_dir):/tmp/files \
		-d mysql:$(tag)

.PHONY: spell-check
spell-check:
	# npm install -g cspell@latest
	cspell lint --config .vscode/cspell.json ".*"; \
	cspell lint --config .vscode/cspell.json "**/.*"; \
	cspell lint --config .vscode/cspell.json ".{github,vscode}/**/*"; \
	cspell lint --config .vscode/cspell.json ".{github,vscode}/**/.*"; \
	cspell lint --config .vscode/cspell.json "**"
