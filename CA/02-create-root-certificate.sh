# Use the root key (ca.key.pem) to create a root certificate (ca.cert.pem).
# Give the root certificate a long expiry date, such as twenty years. Once the
# root certificate expires, all certificates signed by the CA become invalid.
#
# Note:
# Whenever you use the req tool, you must specify a configuration file to use
# with the -config option, otherwise OpenSSL will default to
# /etc/pki/tls/openssl.cnf.

pushd CA-Root

openssl req -config openssl.cnf \
    -key private/ca.key.pem \
    -new -x509 -days 7300 -sha256 -extensions v3_ca \
    -out certs/ca.cert.pem

popd
