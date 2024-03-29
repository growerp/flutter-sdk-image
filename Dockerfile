FROM mobiledevops/android-sdk-image:34.0.0-jdk17

ENV FLUTTER_VERSION="3.19.2"
ENV FLUTTER_HOME "/home/mobiledevops/.flutter-sdk"
ENV PATH $PATH:$FLUTTER_HOME/bin

# Download and extract Flutter SDK
RUN mkdir $FLUTTER_HOME \
    && cd $FLUTTER_HOME \
    && curl --fail --remote-time --silent --location -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
    && tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz --strip-components=1 \
    && rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz

RUN flutter precache

# Install Gcloud
RUN curl https://sdk.cloud.google.com | bash

USER root

# Install Firebase
RUN apt-get update && apt-get install -y nodejs npm
RUN npm install -g firebase-tools

USER mobiledevops
RUN export PATH="/home/mobiledevops/google-cloud-sdk/bin:$PATH" && source ~/.bashrc
