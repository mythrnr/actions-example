.PHONY: check createdb ping pull run

db       ?= db_local
file     ?=
pw       ?= mysqlrootpassword
tag      ?= latest
work_dir := $(shell pwd)

check:
	docker exec mysql-check-ddl-$(db) sh -c \
		"mysql -u root --password=$(pw) < /tmp/files/$(file)"

createdb:
	docker exec mysql-check-ddl-$(db) sh -c \
		"echo \"CREATE SCHEMA IF NOT EXISTS $(db) \
			DEFAULT CHARACTER SET utf8mb4 \
			COLLATE utf8mb4_bin\" \
		| mysql -u root --password=$(pw)"

ping:
	docker exec mysql-check-ddl-$(db) sh -c \
		"echo \"SHOW databases\" \
		| mysql -u root --password=$(pw)"

pull:
	docker pull mysql:$(tag)

run:
	docker run --rm \
		--name mysql-check-ddl-$(db) \
		-e MYSQL_ROOT_PASSWORD=$(pw) \
		-v $(work_dir):/tmp/files \
		-d mysql:$(tag)
