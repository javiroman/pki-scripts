# Generate a new certificate using the new certificate signing request. The new
# signing request is good for 1 year (365 days)
openssl x509 -req -days 365 -in csr/admin.microserviceslab.com.csr.pem -signkey private/admin.microserviceslab.com.key.pem -out certs/admin.microserviceslab.com.cert.pem
