FROM node:22-alpine
WORKDIR /app

COPY package.json yarn.lock* .yarnrc.yml ./
COPY .yarn/releases ./.yarn/releases
RUN node .yarn/releases/yarn-4.14.1.cjs install --immutable

COPY src ./src

EXPOSE 8787
CMD ["node", ".yarn/releases/yarn-4.14.1.cjs", "start"]
