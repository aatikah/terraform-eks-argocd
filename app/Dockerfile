# ---------- Stage 1: Build React Frontend ----------
FROM node:18 AS client-build

WORKDIR /app/client

COPY client/package*.json ./
RUN npm install

COPY client/ ./
RUN npm run build


# ---------- Stage 2: Backend + Serve Frontend ----------
FROM node:18

WORKDIR /app

# Copy backend files
COPY package*.json ./
RUN npm install

COPY . .

# Copy React build from stage 1
COPY --from=client-build /app/client/build ./client/build

# Set environment variables
ENV NODE_ENV=production
ENV PORT=5000

EXPOSE 5000

CMD ["node", "server.js"]
