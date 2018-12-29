yum -y install epel-release
yum -y install httpd
systemctl start httpd 	
systemctl enable httpd 
firewall-cmd --add-service=http --permanent 
firewall-cmd --reload 
yum -y install php php-mbstring php-pear
yum --enablerepo=epel -y install phpMyAdmin php-mysql php-mcrypt
sed -i -e "s#127.0.0.1#127.0.0.1 10.10.0.0/24 #g" /etc/httpd/conf.d/phpMyAdmin.conf
systemctl restart httpd 
