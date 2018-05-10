#FROM node:8.9-alpine
FROM registry.access.redhat.com/rhscl/nodejs-6-rhel7

RUN mkdir -p /app
WORKDIR /app

RUN npm install -g nodemon
RUN npm config set registry https://registry.npmjs.org
COPY package.json /app/package.json
RUN npm install \
 && npm ls \
 && npm cache clean --force \
 && mv /app/node_modules /node_modules
COPY . /app

ENV PORT 4000
EXPOSE 4000

CMD ["node", "server.js"]
