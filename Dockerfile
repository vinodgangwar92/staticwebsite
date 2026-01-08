# Base image
FROM nginx:alpine

# Copy website files into Nginx public folder
COPY . /usr/share/nginx/html

# Expose default http port
EXPOSE 80

# Run nginx server
CMD ["nginx", "-g", "daemon off;"]

