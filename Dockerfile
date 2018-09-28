FROM jameskyburz/graphicsmagick-alpine:v1.2.0 as gm
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
  npm install node-gyp yamljs babel-cli babel-preset-node picture-tube modclean -g && \
  npm install serverless@latest -g

RUN curl https://cache.agilebits.com/dist/1P/op/pkg/v0.5.4/op_linux_386_v0.5.4.zip -o op.zip && \
  unzip op.zip && \
  chmod +x op && \
  mv op /usr/bin && \
  rm -rf op.zip op.sig

RUN curl https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_amd64.zip -o terraform.zip && \
  unzip terraform.zip && \
  chmod +x terraform && \
  mv terraform /usr/bin && \
  rm -rf terraform.zip

RUN curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest && \
  chmod +x /usr/local/bin/ecs-cli

RUN curl -s -L -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.14.2/terragrunt_linux_amd64 && \
  chmod +x /usr/local/bin/terragrunt

WORKDIR /usr/src/app

ADD .babelrc ./
ADD .npmrc ./
