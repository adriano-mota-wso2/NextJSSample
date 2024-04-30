FROM node:18-alpine as build-env
RUN apk add --no-cache g++ make py3-pip libc6-compat
RUN mkdir /app
WORKDIR /app
COPY package*.json ./
EXPOSE 3000
FROM base as builder
WORKDIR /app
COPY . .
RUN npm run build
ENV NODE_ENV=production
RUN npm ci

RUN addgroup -g 10014 choreo && \
    adduser  --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser
RUN addgroup -g 10014 nodejs && \
    adduser  --disabled-password  --no-create-home --uid 10014 --ingroup nodejs choreouser
USER nextjs


COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/public ./public
CMD npm start

FROM base as dev
ENV NODE_ENV=development
RUN npm install 
COPY . .
CMD npm run dev
