# Stage 1: Base image with PHP and necessary extensions
FROM php:8.1-fpm-alpine as base

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli
# Install zip extension
RUN apk add --no-cache libzip-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip
# Install dependencies for PHP extensions
RUN apk add --no-cache $PHPIZE_DEPS \
    && apk add --no-cache libpng-dev libjpeg-turbo-dev freetype-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd
# Install Xdebug dependencies and Xdebug
# RUN apk add --no-cache $PHPIZE_DEPS \
#     && pecl install xdebug-3.1.5 \
#     && docker-php-ext-enable xdebug

# Set the working directory environment variable
ENV WORK_DIR /var/www/application

# Set the entrypoint
ENTRYPOINT ["docker-php-entrypoint"]

# Stage 2: Final image
FROM base
#  Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR ${WORK_DIR}
# Ensure the source directories exist
COPY ./src ${WORK_DIR}
COPY ./data /var/www/


# Install Mezzio Skeleton
# RUN composer create-project mezzio/mezzio-skeleton ${WORK_DIR} --no-interaction --ignore-platform-reqs

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]