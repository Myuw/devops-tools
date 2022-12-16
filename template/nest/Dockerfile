###################
# BUILD FOR LOCAL DEVELOPMENT
###################

# FROM node:18-alpine As DEVELOPMENT
FROM arm64v8/node:lts-alpine3.17 As DEVELOPMENT

WORKDIR /app

COPY --chown=node:node package*.json ./

RUN yarn

RUN mkdir -p node_modules/.cache && chmod -R 777 node_modules/.cache

COPY --chown=node:node . .

USER node

###################
# BUILD FOR PRODUCTION
###################

# FROM node:18-alpine As BUILD
FROM arm64v8/node:lts-alpine3.17 As BUILD

WORKDIR /app

COPY --chown=node:node package*.json ./

COPY --chown=node:node --from=development /app/node_modules ./node_modules

COPY --chown=node:node . .

RUN npm run build

ENV NODE_ENV production

RUN yarn --only=production && yarn cache clean --force

USER node

###################
# PRODUCTION
###################

# FROM node:18-alpine As PRODUCTION
FROM arm64v8/node:lts-alpine3.17 As PRODUCTION

COPY --chown=node:node --from=build /app/node_modules ./node_modules
COPY --chown=node:node --from=build /app/dist ./dist

CMD [ "node", "dist/main.js" ]
