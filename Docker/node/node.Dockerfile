FROM node:16-alpine
WORKDIR /app
COPY . /app
RUN npm install
RUN npm install pm2@latest -g
#installing pm2 globally
# create ecosystem.config.js to store environments
CMD ["pm2-runtime" , "start" , "ecosystem.config.js" ]
#intiallinzing pm2 using ecosystem.config.js
#CMD ["node" , "server.js"]