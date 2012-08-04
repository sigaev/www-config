sudo yum -y update
sudo yum -y install git git-daemon httpd make
mkdir www
chmod 755 . www

(
	umask 077
	git apply <<EOF
--- a/.ssh/authorized_keys
+++ b/.ssh/authorized_keys
@@ -1 +1,5 @@
 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCTmi09EFWwoEV13eDkKeufaI6RMiC4lFkqe6ZtqRTxKjKTDxyEXaZP44uQJsG49kWw8GHSBIVYOFNyMsakx8Stx9cZwLVmnUkSNtyOP1jRV4MX2C0FLONKUMqgBHPj+Fwf7RCQg4XYpGtcWpvgH6CuN+hE/F8z8owwugr10MzA7LAr7CUk7I2o8RitF9E0oUZCjlaV/1aH/YmtAmUijeGLMps5KjNyLIMuXtWwsiyZxiIovjJ5pX7osAWW6dVAg0S0ZhA+pn1FY1q2P9tzljd1EourGO0OAaldOYBRJ/eqBuLKAlZD5ZjRovf077d61k3PPF+mG8BOCQ8mRnI9wAXd sigaev
+ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAu0VxJFLdQTLmvyIUWvHOMmgICJ2oSzX0UIWYDpZvMOY2y4kC494i5Rv0emp+KdJCPcL13rTpjrAJFJp+rUKN2pWkYLTnD2eH14gvA7Or0RhjOxuFd5y9IN0zT9/ArAnSZHllpB2XwYixuUat+cEbYyTeNollYiIN/pWn67M7Koc= sigaev@amarillo
+ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKvvgHLAYxZC0Pd0NU77BxPeOB6uuO1+ZabpWzwRO7nMvjU9JwUtveQkX+a9uiGuOfHYy1GaTsLK5I+dix7iO9Ie/jBtrUwdGj7/4vPp1oniKta+U5z4JyBHTwTAa8K2sFcNZWoqdDgv6TbBHl8z/5uplRz43rmnCGgN3yg4gH0yRjnreRGAKUuGiROUEb4wqhJV4Qii/vFRaThshEb1a4wYZXYA50nRLflEOZtGGtznJMJlh2FfVwS24pP5D9XiKNNkbslkvj8TpUojiYNARJy46xDH53XmNXf/kw54XGozcnDAdo0mXzAUrG8hdhIMxNXd152ibNkeqCMD3oxh35 sigaev@core-i
+ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzSMJKVXf7Swuf3NdAayG44xxe0LQN403ky7k6BUBm8hRqW05zHSz+3KKLnOoya/H4/oiyh8024IBHHibI8Y06rpHEZxCQg6OW2APA514ODHROB8nGO+YoBCd9xT3UrQVjK5xNfnV2a4IfsbUO7lYKqOinDK+w0OtOjZIdMxCY/5PXy4H04x3sOeZW4J4+wOVIWnWZrDkLKEsvssc7mQhm2gVKlxPuXolNfOxBk1YaVSnD0ZSYizfCQu01RBRUvq5sBlW06KVOnLMAWvYruq/gMo3NoBqzKe/PNd0bbDtHBZNqNbyRXPJKqgyW7PSryEQVbwaufumrOByBAn7HsnnD sigaev@amarillo.nyc.corp.google.com
+ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8V0r+MVOS1OTfZux4lMzpSCJz+Ax0762snwQf2qziHaa5Kwmy6+fndseey1dyHJAXoolIXw4Zuuz+b6Cw5mjzPeQ7ICHJ+iCT+dA/NUGKQY2Gpgm8qpz+J0nRifg8fyJ2nHsGtu90JkJsselb5WFBz9rdMxp8ZqjrhPp/ecutMqGm0dctcjRvjT2WL5niE9bGzTV/E0ek21gbyiVIN2N8bh0u5XpGnBL9IH4x22veqIVjFdRToaJ3GnOnFsdZVD0YquqoY++q088IRUVOObrqyvakVHLafSej63gUhQHP1c4c4TtUioxeR9viwLu6JBlUvQjbt4DFuvSwMnwRBYaj sigaev@rkehoe
EOF
)

git clone --bare git://github.com/sigaev/www-config .git
git diff master...patch | sudo git apply -v --directory=/
git clone git://github.com/sigaev/aws aws
cd aws
sudo make
cd
rm -fr .git aws

for i in httpd xinetd; do
	sudo /sbin/chkconfig $i on
	sudo /sbin/service $i start
done
ssh-keygen -t rsa -N '' -f .ssh/id_rsa
