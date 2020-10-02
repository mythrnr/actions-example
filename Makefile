.PHONY: check createdb pull run

tag  ?= latest
db   ?= db_local
file ?=
pw   ?= mysqlrootpassword

check:
	docker exec mysql-check-ddl-$(db) \
		mysql -u root --password=$(pw) < $(file)

createdb:
	SQL="CREATE SCHEMA IF NOT EXISTS $(db) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
	docker exec mysql-check-ddl-$(db) sh -c \
		'echo $$SQL | mysql -u root --password=$(pw)'

ping:
	SQL="SHOW databases"
	docker exec mysql-check-ddl-$(db) sh -c \
		'echo $$SQL | mysql -u root --password=$(pw)'

pull:
	docker pull mysql:$(tag)

run:
	docker run --rm \
		--name mysql-check-ddl-$(db) \
		-e MYSQL_ROOT_PASSWORD=$(pw) \
		-d mysql:$(tag)
