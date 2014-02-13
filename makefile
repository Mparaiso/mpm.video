#
# TARGETS
# =======
# 
# test: test
# commit: commit to repository
# compile: build project
# push: push to repository
# run: run app server on localhost:3000
# @DEBUG=express:* 
test: compile
	@NODE_ENV=testing mocha -R spec 
cover:
	@NODE_ENV=testing node_modules/.bin/istanbul cover node_modules/mocha/bin/_mocha -- -R spec  
compile: 
	@coffee -c -m -b -o js coffee
commit: compile
	@git add .
	@git commit -am"$(message) `date`" | : 
push: commit
	@git push origin master --tags
run: compile
	NODE_ENV=development supervisor -w 'js,views' -e 'less|js|html' app.js &
deploy: test commit
	@git push heroku master
.PHONY: run test commit push compile deploy
