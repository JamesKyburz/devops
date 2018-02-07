FROM jameskyburz/graphicsmagick-alpine:v1.0.0 as gm
FROM node:6.10.3-alpine

COPY --from=gm /usr/ /usr/

LABEL maintainer="James Kyburz james.kyburz@gmail.com"

ENV NPM_CONFIG_LOGLEVEL warn

RUN mkdir -p /root/.config
RUN chown -R $USER:$(id -gn $USER) /root/.config

RUN apk --no-cache add \
  openssh \
  openssl \
  bash \
  groff \
  jq \
  git \
  g++ \
  gcc \
  libgcc \
  libstdc++ \
  linux-headers \
  make \
  python \
  curl \
  docker \
  py-pip && \
  pip install --upgrade pip && \
  pip install awscli && \
  pip install docker-compose && \
  yarn global add npm@latest && \
  npm uninstall yarn -g && \
  npm install node-gyp yamljs serverless babel-cli babel-preset-node -g

RUN curl https://cache.agilebits.com/dist/1P/op/pkg/v0.2.1/op_linux_386_v0.2.1.zip -o op.zip && \
  unzip op.zip && \
  chmod +x op && \
  mv op /usr/bin && \
  rm -rf op.zip op.sig

RUN curl https://releases.hashicorp.com/terraform/0.11.2/terraform_0.11.2_linux_amd64.zip -o terraform.zip && \
  unzip terraform.zip && \
  chmod +x terraform && \
  mv terraform /usr/bin && \
  rm -rf terraform.zip

RUN curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest && \
  chmod +x /usr/local/bin/ecs-cli

WORKDIR /usr/src/app

ADD .babelrc ./
ADD .npmrc ./
