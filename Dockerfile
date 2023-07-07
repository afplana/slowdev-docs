FROM nginx:1
ENV NODE_ENV=production
RUN echo "OK" > /usr/share/nginx/html/healthz.txt
COPY docs /usr/share/nginx/html/
