# An intermediate certificate authority (CA) is an entity that can sign
# certificates on behalf of the root CA. The root CA signs the intermediate
# certificate, forming a chain of trust.

# The purpose of using an intermediate CA is primarily for security. The root key
# can be kept offline and used as infrequently as possible. If the intermediate
# key is compromised, the root CA can revoke the intermediate certificate and
# create a new intermediate cryptographic pair.

pushd CA-Intermediate

# Create the intermediate key (intermediate.key.pem). Encrypt the intermediate
# key with AES 256-bit encryption and a strong password.

openssl genrsa -aes256 \
    -out private/intermediate.key.pem 4096

popd
