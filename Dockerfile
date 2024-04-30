FROM node:18-alpine as build-env
RUN apk add --no-cache g++ make py3-pip libc6-compat
RUN mkdir /app
WORKDIR /app
COPY package*.json ./
EXPOSE 3000
FROM base as builder
WORKDIR /app

