FROM node:alpine AS builder

COPY . /pdf-filler
WORKDIR /pdf-filler

RUN npm install && npm run build --prod

FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf

COPY --from=builder /pdf-filler/dist/* /usr/share/nginx/html/
