# Use the latest Rust image to build mdBook
FROM rust:latest AS builder

# Install mdBook
RUN cargo install mdbook

# Create app directory
WORKDIR /app

# Clone the GitHub repository (replace with your repo URL)
# ARG REPO_URL=<your-repo-url>
# RUN git clone $REPO_URL .

# Copy the book source (if using a local directory, uncomment this line and comment the git clone above)
COPY . .

# Build the book
RUN mdbook build

# Use a small web server to serve the book
FROM alpine:latest


# Install a simple HTTP server
RUN apk add --no-cache darkhttpd

# Copy the built book from the builder
COPY --from=builder /app/book /book

# Expose port
EXPOSE 8080

# We run as a user
USER nonroot
# Serve the book
CMD ["darkhttpd", "/book", "--port", "8080"]
