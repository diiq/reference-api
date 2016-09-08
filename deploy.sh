#!/usr/bun/bash

git push heroku master &&
  heroku run rake db:migrate permissions:seed;
