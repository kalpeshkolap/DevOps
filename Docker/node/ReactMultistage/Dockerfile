FROM node:22.3.0-alpine3.20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


#reference nginx conf file

# server {
#     listen 80;
#     server_name _;
#     location / {
#         root   /usr/share/nginx/html;
#         index  index.html index.htm;
#         try_files $uri $uri/ /index.html;
#     }
#     error_page  500 502 503 504 /50x.html;
#     location = /50x.html {
#         root   /usr/share/nginx/html;
#     }
# }
