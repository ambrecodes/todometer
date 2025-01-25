# Step 1: Build the React app
FROM node:16 as build

WORKDIR /app
COPY package.json package-lock.json ./

# Install system dependencies required by Electron
RUN apt-get update && apt-get install -y \
    libnss3 \
    libxss1 \
    libgdk-pixbuf2.0-0 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libnspr4 \
    libx11-xcb1 \
    libgbm1 \
    libnss3-dev \
    libgtk-3-0 \
    libx11-6

# Install the project dependencies listed in package.json using npm
RUN npm install --legacy-peer-deps

# Copy the rest of the application's source code into the /app directory in the container
COPY . ./

# Build the React app
RUN npm run build

# Step 2: Serve the React app using a simple HTTP server
FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
