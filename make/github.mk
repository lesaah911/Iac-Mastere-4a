.PHONY: gh.create gh.var gh.vlist

gh.create:
	@echo "Creating GitHub repository: $(GITHUB_REPO)"
	@gh repo create $(GITHUB_REPO) \
		--$(VISIBILITY) \
		--source=. \
		--push

gh.var:
	@gh variable set $(VAR_KEY) --body "$(VAR_VALUE)"

gh.vlist:
	@gh variable list
