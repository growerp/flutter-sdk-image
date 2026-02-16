FROM mobiledevops/android-sdk-image:33.0.2

ENV FLUTTER_VERSION="3.41.1"
ENV CHANNEL="stable"
ENV FLUTTER_HOME="/home/mobiledevops/.flutter-sdk"
ENV PATH=$PATH:$FLUTTER_HOME/bin

# Download and extract Flutter SDK
RUN mkdir $FLUTTER_HOME \
    && cd $FLUTTER_HOME \
    && curl --fail --remote-time --silent --location -O https://storage.googleapis.com/flutter_infra_release/releases/${CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz \
    && tar xf flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz --strip-components=1 \
    && rm flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz

# Install NDK required by Flutter 3.41 (28.2.13676358)
USER root
RUN ANDROID_SDK=/opt/android-sdk-linux && \
    rm -rf $ANDROID_SDK/ndk/* && \
    yes | $ANDROID_SDK/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_SDK --install "ndk;28.2.13676358" && \
    test -f $ANDROID_SDK/ndk/28.2.13676358/source.properties
USER mobiledevops

RUN flutter precache
