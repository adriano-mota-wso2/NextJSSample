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

RUN npm run build
ENV NODE_ENV=production
RUN npm ci

COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/public ./public
CMD npm start

FROM node:latest as dev
RUN npm i 
ENV NODE_ENV=development
RUN npm install 
COPY . .
CMD npm run dev
