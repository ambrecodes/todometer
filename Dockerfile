# Step 1: Build the React app
# Use an official Node.js image with version 16 as the base image
FROM node:16 as build

# Set the working directory inside the container to /app
WORKDIR /app

# Copy the package.json and package-lock.json files into the container's /app directory
COPY package.json package-lock.json ./

# Install the project dependencies listed in package.json using npm
RUN npm install

# Copy the rest of the application's source code into the /app directory in the container
COPY . ./

# Build the React app by running the build script defined in package.json
RUN npm run build

# Step 2: Serve the React app using a simple HTTP server
# Use an official Nginx image with the Alpine Linux variant as the base image
FROM nginx:alpine

# Copy the build output from the 'build' stage into the Nginx server's HTML directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to allow HTTP traffic to reach the container
EXPOSE 80

# Use the default Nginx command to start the server and keep it running in the foreground
CMD ["nginx", "-g", "daemon off;"]
