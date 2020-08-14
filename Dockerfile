FROM nginx:1.19.1-alpine
ADD dist/ /usr/share/nginx/html
