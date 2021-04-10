FROM node:14.16
RUN npm install -g http-server
RUN mkdir /app
ADD . /app
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
EXPOSE 8080
CMD [ "http-server", "dist" ]

