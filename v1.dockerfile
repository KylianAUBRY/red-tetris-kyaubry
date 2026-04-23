FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ARG VITE_APP_VERSION=v1
ENV VITE_APP_VERSION=$VITE_APP_VERSION
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev
COPY src/ ./src/
COPY --from=builder /app/dist ./dist
ENV NODE_ENV=production
EXPOSE 8888
CMD ["node", "src/server/index.js"]
