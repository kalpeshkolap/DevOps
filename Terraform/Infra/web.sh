    #! /bin/bash
    sudo yum update -y
    sudo yum install httpd -y     
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo echo "welcome" > /var/www/html/index.html
    sudo systemctl restart httpd
