sudo yum -y update
sudo yum -y install git httpd
mkdir www
chmod 755 . www

(
	umask 077
	git apply <<EOF
--- a/.ssh/authorized_keys
+++ b/.ssh/authorized_keys
@@ -1 +1,2 @@
 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCTmi09EFWwoEV13eDkKeufaI6RMiC4lFkqe6ZtqRTxKjKTDxyEXaZP44uQJsG49kWw8GHSBIVYOFNyMsakx8Stx9cZwLVmnUkSNtyOP1jRV4MX2C0FLONKUMqgBHPj+Fwf7RCQg4XYpGtcWpvgH6CuN+hE/F8z8owwugr10MzA7LAr7CUk7I2o8RitF9E0oUZCjlaV/1aH/YmtAmUijeGLMps5KjNyLIMuXtWwsiyZxiIovjJ5pX7osAWW6dVAg0S0ZhA+pn1FY1q2P9tzljd1EourGO0OAaldOYBRJ/eqBuLKAlZD5ZjRovf077d61k3PPF+mG8BOCQ8mRnI9wAXd sigaev
+ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAu0VxJFLdQTLmvyIUWvHOMmgICJ2oSzX0UIWYDpZvMOY2y4kC494i5Rv0emp+KdJCPcL13rTpjrAJFJp+rUKN2pWkYLTnD2eH14gvA7Or0RhjOxuFd5y9IN0zT9/ArAnSZHllpB2XwYixuUat+cEbYyTeNollYiIN/pWn67M7Koc= sigaev@amarillo
EOF
)

git clone --bare http://sigaev.com/about/www/.git .git
git diff master...patch | sudo git apply --directory=/
rm -fr .git

sudo /sbin/chkconfig httpd on
sudo /sbin/service httpd start
ssh-keygen -t rsa -N '' -f .ssh/id_rsa
