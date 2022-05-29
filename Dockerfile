FROM node:lts-alpine as step1

RUN yarn global add @magento/pwa-buildpack --prefix /usr/local && yarn add compression --save

ARG pwa_template='@magento/venia-concept'

RUN /usr/local/bin/buildpack create-project /app/pwa \
      --template ${pwa_template} \
      --name pwa \
      --author 'Victor' \
      --npmClient yarn \
      --install


WORKDIR /app/pwa

COPY .env /app/pwa/.env
RUN yarn add @magento/venia-sample-payments-checkmo && \
    yarn build:prod




FROM node:lts-alpine
ENV STAGING_SERVER_PORT=10000 NODE_ENV=production

COPY --from=step1 /app/pwa/ /app/
WORKDIR /app
CMD ["yarn","start"]
EXPOSE 10000