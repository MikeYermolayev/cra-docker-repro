FROM node:12.16.3-alpine AS builder

ENV CI=true \
  NODE_ENV=production \
  GENERATE_SOURCEMAP=false \
  SKIP_PREFLIGHT_CHECK=true

WORKDIR /usr/src/app

# Install

COPY package.json ./
COPY package-lock.json ./

RUN npm ci --ignore-scripts --no-optional

# Build

COPY src ./src
COPY public ./public

RUN npm run build

RUN for f in $(find ./build -type f -name '*.html' -o -name '*.ico' -o -name '*.css' -o -name '*.js' -o -name '*.json' -o -name '*.map'); \
  do gzip -9c "$f">"$f.gz"; \
  done
