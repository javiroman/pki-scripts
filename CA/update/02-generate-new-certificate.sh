# Generate a new certificate signing request using the existing
# ssl/testingcert.key private key
openssl req -config openssl-intermediate.cnf -new -key private/admin.microserviceslab.com.key.pem -out csr/admin.microserviceslab.com.csr.pem 
