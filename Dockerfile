FROM ubuntu:16.04

ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

COPY android-accept-licenses.sh /opt

RUN apt-get update \
  && apt-get install bsdtar -y \
  && apt-get install default-jdk wget expect git -y \
  && dpkg --add-architecture i386 \
  && apt-get -qqy update \
  && apt-get -qqy install libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
  && mkdir /opt/android-sdk-linux \
  && wget -qO- https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip | bsdtar -xvf- -C /opt/android-sdk-linux \
  && rm -rf /var/lib/apt/lists/*

# RUN /opt/android-accept-licenses.sh "/opt/android-sdk-linux/tools/android update sdk -a -u -t tools,platform-tools,build-tools-24.0.3,android-23,android-24,extra-android-m2repository,extra-google-m2repository" \
#  && rm -rf /var/lib/apt/lists/*

RUN chmod -R 777 /opt/android-sdk-linux \
  && yes | /opt/android-sdk-linux/tools/bin/sdkmanager --licenses \
  && /opt/android-sdk-linux/tools/bin/sdkmanager "tools" "platforms;android-25" "platform-tools" "build-tools;25.0.3" "extras;android;m2repository" "extras;google;m2repository" \
  && rm -rf /var/lib/apt/lists/*

# Maven 3
ENV MAVEN_VERSION 3.3.9
ENV M2_HOME "/usr/local/apache-maven/apache-maven-${MAVEN_VERSION}"
RUN wget --quiet "http://mirror.dkd.de/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" && \
  mkdir -p /usr/local/apache-maven && \
  mv "apache-maven-${MAVEN_VERSION}-bin.tar.gz" /usr/local/apache-maven && \
  tar xzvf "/usr/local/apache-maven/apache-maven-${MAVEN_VERSION}-bin.tar.gz" -C /usr/local/apache-maven/ && \
  update-alternatives --install /usr/bin/mvn mvn "${M2_HOME}/bin/mvn" 1 && \
  update-alternatives --config mvn
  
