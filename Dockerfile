FROM mhart/alpine-node
COPY . /app
CMD node index.js
EXPOSE 3700