# Step 1: Use a Flutter base image to install Flutter
FROM cirrusci/flutter:stable

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the Flutter project files into the container
COPY . .

# Step 4: Install Flutter dependencies
RUN flutter pub get

# Step 5: Build the Flutter web app
RUN flutter build web

# Step 6: Use Nginx to serve the web app
FROM nginx:stable
COPY --from=0 /app/build/web /usr/share/nginx/html

# Step 7: Expose the container port for serving the app
EXPOSE 80
