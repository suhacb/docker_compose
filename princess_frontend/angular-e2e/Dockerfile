FROM node:22-alpine
RUN npm install -g @angular/cli
WORKDIR /var/www/html
CMD ["ng", "serve", "--configuration=e2e", "--host", "0.0.0.0", "--port", "4201"]
EXPOSE 4201
