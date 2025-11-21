# ---------------------------
# 1. Base image for building
# ---------------------------
FROM node:18-alpine AS builder

# Create app directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Copy everything
COPY . .

# Build Next.js app
RUN npm run build

# ---------------------------
# 2. Production runtime image
# ---------------------------
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# Copy only necessary build output
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./next.config.js

# Expose port
EXPOSE 3000

# Start Next.js Server
CMD ["npm", "start"]
