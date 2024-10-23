# FROM 498907343309.dkr.ecr.ap-southeast-1.amazonaws.com/prj-ecr-dev:18-alpine3.16 // ARM64

FROM node:18-alpine3.16

WORKDIR /app

COPY ./package*.json ./

RUN npm install

COPY . .

RUN npm run build && chmod a+x entrypoint.sh

EXPOSE 3000

ENTRYPOINT [ "./entrypoint.sh" ]