FROM node:18-alpine

WORKDIR /app

ENV NODE_ENV=production

# Install dependencies before app source so npm install stays cached when code changes.
COPY package.json ./

RUN npm install --omit=dev

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
