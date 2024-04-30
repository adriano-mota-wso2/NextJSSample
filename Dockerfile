FROM node:18-alpine as build-env
RUN addgroup -g 10014 choreo && \
    adduser  --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser
RUN addgroup -g 10014 nodejs && \
    adduser  --disabled-password  --no-create-home --uid 10014 --ingroup nodejs choreouser
USER nextjs

RUN apk add --no-cache g++ make py3-pip libc6-compat
RUN mkdir /app
WORKDIR /app
COPY package*.json ./
EXPOSE 3000
FROM base as builder
WORKDIR /app

