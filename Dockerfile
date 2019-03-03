FROM node:boron

ENV CHROME_DEB "google-chrome-stable_65.0.3325.181-1_amd64.deb"
ENV CHROME_URL "https://s3.amazonaws.com/gitlab-google-chrome-stable/${CHROME_DEB}"
ENV JAVA_HOME "/usr/lib/jvm/java-8-openjdk-amd64/"

RUN apt-get update -q -y && \
    apt-get --yes install libnss3 && \
    apt-get --yes install libgconf-2-4 && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean && \
    apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f

RUN curl --silent --show-error --fail -O $CHROME_URL && \
    dpkg -i ./$CHROME_DEB || true && \
    apt-get install -f -y && \
    rm -f $CHROME_DEB

RUN npm install chromedriver@2.36.0 -g && \
    npm install https://gitlab.com/gitlab-org/gitlab-selenium-server.git -g
