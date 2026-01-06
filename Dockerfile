FROM nginx:alpine

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

RUN apk add --no-cache \
build-base \
curl 

COPY /app/index.html .

EXPOSE 80