

build:
	@echo "Building..."
	pnpm run build
	docker build -t esport-helper

run:
	@echo "Running..."
	docker run -d -p 3000:80 --name esport-helper esport-helper

