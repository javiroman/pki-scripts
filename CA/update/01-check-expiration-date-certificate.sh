# Check expiration data of HAproxy certificate
openssl x509 -in admin.microserviceslab.com.cert.pem -noout -enddate
