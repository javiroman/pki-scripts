# We will be signing certificates using our intermediate CA. You can use these
# signed certificates in a variety of situations, such as to secure connections
# to a web server or to authenticate clients connecting to a service.

# The steps below are from your perspective as the certificate authority. A
# third-party, however, can instead create their own private key and
# certificate signing request (CSR) without revealing their private key to you.
# They give you their CSR, and you give back a signed certificate. In that
# scenario, skip the genrsa and req commands.

#----------------------------------
# Create a key
#----------------------------------

# Our root and intermediate pairs are 4096 bits. Server and client certificates
# normally expire after one year, so we can safely use 2048 bits instead.

# Note: Although 4096 bits is slightly more secure than 2048 bits, it slows
# down TLS handshakes and significantly increases processor load during
# handshakes. For this reason, most websites use 2048-bit pairs.

# Note: If you’re creating a cryptographic pair for use with a web server (eg,
# Apache), you’ll need to enter this password every time you restart the web
# server. You may want to omit the -aes256 option to create a key without a
# password.

pushd CA-Intermediate
#openssl genrsa -aes256 -out intermediate/private/www.example.com.key.pem 2048
openssl genrsa -out private/admin.microserviceslab.com.key.pem 2048

#----------------------------------
# Create the certificate
#----------------------------------

# Use the private key to create a certificate signing request (CSR). The CSR
# details don’t need to match the intermediate CA. 
# 1. For server certificates, the Common Name must be a fully qualified 
#    domain name (eg, www.example.com),
# 2. whereas for client certificates it can be any unique identifier (eg, an
#    e-mail address). 
#
# WARNING: that the Common Name cannot be the same as either your root or 
# intermediate certificate.

echo
echo "Creating a Server cerfificate signing request (CSR).... "
echo

openssl req \
    -config openssl-intermediate.cnf \
    -key private/admin.microserviceslab.com.key.pem \
    -new -sha256 -out csr/admin.microserviceslab.com.csr.pem

# To create a certificate, use the intermediate CA to sign the CSR. If the
# certificate is going to be used 
#    1. on a server, use the server_cert extension.
#    2. If the certificate is going to be used for user authentication, use the
#       usr_cert extension. 

# Certificates are usually given a validity of one year,
# though a CA will typically give a few days extra for convenience.

echo
echo "Creating the Server Cerfificate .... "
echo

openssl ca \
    -config openssl-intermediate.cnf \
    -extensions server_cert \
    -days 375 \
    -notext \
    -md sha256 \
    -in csr/admin.microserviceslab.com.csr.pem \
    -out certs/admin.microserviceslab.com.cert.pem

popd
