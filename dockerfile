FROM node:20-alpine3.18
WORKDIR /app
COPY package*.json ./

COPY . .
RUN npm install
EXPOSE 3000
ENTRYPOINT ["node","index.js"]
