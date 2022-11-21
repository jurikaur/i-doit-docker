FROM scratch
ADD ubuntu-jammy-oci-amd64-root.tar.gz /
RUN apt-get update && apt-get install -y \
    package-bar \
    package-baz \
    package-foo  \
    && rm -rf /var/lib/apt/lists/*
CMD ["apache2","-DFOREGROUND"]
EXPOSE 80
