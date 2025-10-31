.PHONY: help install install-experimental install-mods update-mods list-mods start start-debug stop restart status update logs logs-tail docker-up docker-down docker-logs docker-shell

help:
	@echo "DayZ Server Management Makefile"
	@echo ""
	@echo "Installation:"
	@echo "  make install                - Install stable DayZ server"
	@echo "  make install-experimental   - Install experimental DayZ server"
	@echo "  make install-mods           - Install configured mods"
	@echo ""
	@echo "Server Management:"
	@echo "  make start                  - Start the server (background)"
	@echo "  make start-debug            - Start the server (foreground, debug mode)"
	@echo "  make stop                   - Stop the server"
	@echo "  make restart                - Restart the server"
	@echo "  make status                 - Show server status"
	@echo "  make update                 - Update server files"
	@echo ""
	@echo "Mod Management:"
	@echo "  make list-mods              - List configured mods"
	@echo "  make add-mod ID=id NAME=nm  - Add a mod (e.g. make add-mod ID=1559212036 NAME=@cf)"
	@echo "  make remove-mod NAME=name   - Remove a mod"
	@echo "  make update-mods            - Update all mods"
	@echo ""
	@echo "Logging:"
	@echo "  make logs                   - View last 100 lines of server log"
	@echo "  make logs-tail              - Follow server logs in real-time"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-up              - Start Docker development environment"
	@echo "  make docker-down            - Stop Docker environment"
	@echo "  make docker-logs            - View Docker logs"
	@echo ""

install:
	@./cmd/install --stable

install-experimental:
	@./cmd/install --experimental

install-mods:
	@./cmd/mods --install

update-mods:
	@./cmd/mods --update

list-mods:
	@./cmd/mods --list

add-mod:
	@./cmd/mods --add $(ID) $(NAME)

remove-mod:
	@./cmd/mods --remove $(NAME)

start:
	@./cmd/server start

start-debug:
	@./cmd/server start --debug

stop:
	@./cmd/server stop

status:
	@./cmd/server status || echo "[*] Server is not running"

restart: stop start

update:
	@./cmd/server update

logs:
	@tail -100 logs/server.log 2>/dev/null || echo "No logs yet"

logs-tail:
	@tail -f logs/server.log 2>/dev/null || echo "No logs yet"

docker-up:
	@docker-compose up -d

docker-down:
	@docker-compose down

docker-logs:
	@docker-compose logs -f

docker-shell:
	@docker exec -it dayz-server bash

.DEFAULT_GOAL := help
