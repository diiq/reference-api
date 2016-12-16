Install

redis
imagemagick


Renew SSL:

sudo certbot renew
sudo heroku certs:update /etc/letsencrypt/live/api.reference-board.com/fullchain.pem /etc/letsencrypt/live/api.reference-board.com/privkey.pem