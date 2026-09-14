FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build


FROM nginx:1.27-alpine

COPY docker/frontend/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

RUN sed -i 's/listen 80;/listen 8080;/' /etc/nginx/conf.d/default.conf \
    && sed -i 's/listen \[::\]:80;/listen [::]:8080;/' /etc/nginx/conf.d/default.conf \
    && sed -i 's|pid[[:space:]]*/run/nginx.pid;|pid /tmp/nginx.pid;|' /etc/nginx/nginx.conf \
    && mkdir -p /var/cache/nginx /var/log/nginx /tmp/nginx \
    && chown -R nginx:nginx /var/cache/nginx /var/log/nginx /tmp/nginx /usr/share/nginx/html /etc/nginx/conf.d \
    && touch /tmp/nginx.pid \
    && chown nginx:nginx /tmp/nginx.pid

USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
