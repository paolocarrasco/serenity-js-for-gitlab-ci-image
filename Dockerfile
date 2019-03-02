FROM node:boron

ENV CHROME_DEB "google-chrome-stable_65.0.3325.181-1_amd64.deb"
ENV CHROME_URL "https://s3.amazonaws.com/gitlab-google-chrome-stable/${CHROME_DEB}"
ENV JAVA_HOME "/usr/lib/jvm/java-8-openjdk-amd64/"

# Dependencies for chromedriver, https://gist.github.com/mikesmullin/2636776#gistcomment-1742414
# Otherwise we get this error: "error while loading shared libraries: libnss3.so: cannot open shared object file: No such file or directory"
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

# Install chrome
# Based off of
# - https://gitlab.com/gitlab-org/gitlab-build-images/blob/9dadb28021f15913a49897126a0cd6ab0149e44f/scripts/install-chrome
# - https://askubuntu.com/a/510186/196148
#
# # Install chrome version from apt-get
# # -----------------------------------------------
# # Add key
# - curl -sS -L https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
# # Add repo
# - echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
# - apt-get update -q -y
# # TODO: Lock down the version
# - apt-get install -y google-chrome-stable
#
# Manually install chrome version from GitLab CDN
# -----------------------------------------------
RUN curl --silent --show-error --fail -O $CHROME_URL && \
    dpkg -i ./$CHROME_DEB || true && \
    apt-get install -f -y && \
    rm -f $CHROME_DEB

RUN npm install chromedriver@2.36.0 -g && \
    npm install https://gitlab.com/gitlab-org/gitlab-selenium-server.git -g
    # The `&` at the end causes it to run in the background and not block the following commands
