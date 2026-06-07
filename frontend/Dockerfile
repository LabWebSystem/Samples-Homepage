FROM node:22-alpine AS builder
WORKDIR /app

ARG VITE_API_BASE_URL=
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

COPY package.json yarn.lock* .yarnrc.yml ./
COPY .yarn/releases ./.yarn/releases
RUN node .yarn/releases/yarn-4.14.1.cjs install --immutable

COPY . .
RUN node .yarn/releases/yarn-4.14.1.cjs build

FROM node:22-alpine
WORKDIR /app

COPY --from=builder /app/package.json /app/yarn.lock /app/.yarnrc.yml ./
COPY --from=builder /app/.yarn/releases ./.yarn/releases
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/vite.config.ts ./vite.config.ts

EXPOSE 4173
CMD ["node", ".yarn/releases/yarn-4.14.1.cjs", "preview", "--host", "0.0.0.0"]
