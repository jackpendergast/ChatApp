FROM mhart/alpine-node
COPY . /
CMD ["node", "index.js"]
EXPOSE 3700
