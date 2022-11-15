# Pull the official base image
FROM node:alpine as build

# set Working directory
WORKDIR /app

# install application dependencies
RUN npm install -g serve
# installing serve package globally
COPY package.json .
COPY package-lock.json .
RUN npm install

# Copy code
COPY . .
RUN npm run build:dev
# dev = environments
# Run application.
CMD ["serve", "-s", "build"]