serenity-js-for-gitlab-ci-image
===============================

Serenity-JS-ready image for Gitlab-CI builds.
Based on many resources and repositories, among
https://gitlab.com/gitlab-org/gitlab-selenium-server
and StackOverflow answers.

In the gitlab-ci.yml file it will be needed to put something like this:

```yml
image: docker.io/paolocarrasco/serenity-js-for-gitlab-ci:<version>

cache:
  paths:
    - node_modules/


stages:
  - build
  - test


build:
  stage: build
  script:
    - npm install
  artifacts:
    expire_in: 3 days
    paths:
      - node_modules/

execute-examples:
  stage: test
  script:
    - nohup chromedriver --port=4444 --url-base=wd/hub &
    - nohup gitlab-selenium-server &
    # Run your tests
    - npm run test-ci
    # Show the logs for the GitLab Selenium Server service
    - mkdir -p selenium/ && curl -s http://localhost:4545/logs.tar.gz | tar -xvzf - -C selenium/
    - mkdir -p selenium/ && curl http://localhost:4545/server-log --output selenium/server-log.txt
  artifacts:
    when: always
    paths:
      - target/site/serenity
  variables:
    SELENIUM_REMOTE_URL: http://localhost:4545/wd/hub
    GITLAB_TARGET_SELENIUM_REMOTE_URL: http://localhost:4444/wd/hub
```
