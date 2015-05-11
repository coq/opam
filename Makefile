all:
	./scripts/post-update.hook
	./scripts/repo2web.lua www/index.html.in \
		core-dev \
		extra-dev \
		released \
		stable-8.4 \
		stable-8.5
