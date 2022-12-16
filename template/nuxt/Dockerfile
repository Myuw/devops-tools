# FROM --platform=linux/amd64 node:lts-alpine3.17 AS DEVELOPMENT
FROM arm64v8/node:lts-alpine3.17 AS DEVELOPMENT

# Create destination directory
WORKDIR /app

# Node option
ENV NODE_OPTIONS=--openssl-legacy-provider

# Update, install dependency and git
# RUN apk update && apk upgrade
# RUN apk add git

# Copy package.json
COPY package*.json ./

# Install dependencies
RUN yarn install

# Build the app
RUN yarn run build

# Copy the app, note .dockerignore
COPY . .

CMD [ "yarn", "run", "dev" ]