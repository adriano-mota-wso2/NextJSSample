FROM node:latest as base
RUN addgroup -g 10014 choreo && \
    adduser  --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser
USER 10014

RUN apk add --no-cache g++ make py3-pip libc6-compat
RUN mkdir /app
WORKDIR /app
COPY package*.json ./
EXPOSE 3000

FROM node:latest as builder
WORKDIR /app
COPY . .
RUN npm i 

RUN npm run build --prod
ENV NODE_ENV=production
RUN npm ci
