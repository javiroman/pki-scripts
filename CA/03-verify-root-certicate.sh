# The output shows:
#
# - the Signature Algorithm used
# - the dates of certificate Validity
# - the Public-Key bit length
# - the Issuer, which is the entity that signed the certificate
# - the Subject, which refers to the certificate itself
#
# Note: The Issuer and Subject are identical as the certificate is self-signed,
# also note that all root certificates are self-signed.
#
# Note: The output also shows the X509v3 extensions. We applied the 
# v3_ca extension, so the options from [ v3_ca  ] should be reflected 
# in the output.

pushd CA-Root

openssl x509 -noout -text -in certs/ca.cert.pem | less

popd
