FROM node:18-alpine as build-env
RUN addgroup -g 10014 choreo && \
    adduser  --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser
USER 10014

RUN apk add --no-cache g++ make py3-pip libc6-compat
RUN mkdir /app
WORKDIR /app
COPY package*.json ./
EXPOSE 3000
FROM base as builder
WORKDIR /app

