serenity-js-for-gitlab-ci-image
===============================

Serenity-JS-ready image for Gitlab-CI builds.
Based on many resources and repositories, among
https://gitlab.com/gitlab-org/gitlab-selenium-server,
https://github.com/SeleniumHQ/docker-selenium,
https://github.com/elgalu/docker-selenium,
and a few StackOverflow answers.

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

execute-examples:
  stage: test
  script:
    - nohup chromedriver --port=4444 --url-base=wd/hub &
    - nohup gitlab-selenium-server &
    - npm test
  artifacts:
    when: always
    paths:
      - target/site/serenity
```
