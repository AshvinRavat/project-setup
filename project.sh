#!/bin/bash



# Function to create a new Laravel project
create_laravel_project() {
    cd /var/www/html
    composer create-project --prefer-dist laravel/laravel $1
}

# Function to create a virtual host configuration
create_virtual_host() {
    sudo cat << EOF > /etc/apache2/sites-available/$1.example.conf

<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName $1.local
    #ServerAlias www.example.com
    DocumentRoot /var/www/html/$1/public

    <Directory /var/www/html/$1/public>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
}

# Function to enable the virtual host
enable_virtual_host() {
    sudo a2ensite $1.example.conf
    #sudo a2dissite 000-default.conf
    sudo systemctl restart apache2

}

# Function to update the hosts file
update_hosts_file() {
    echo "127.0.0.1   $1.local" | sudo tee -a /etc/hosts
}

# Main script execution starts here

#!/bin/bash

# Replace these variables with your MySQL username and password
create_db() {
#!/bin/bash

# Replace these variables with your MySQL username and password
MYSQL_USER="phpmyadmin"
MYSQL_PASSWORD="root"

# Prompt the user to enter the database name

# MySQL command to create the database
MYSQL_PWD="$MYSQL_PASSWORD" mysql -u "$MYSQL_USER" -e "CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;"

}

# Function to set permissions and ownership for Laravel projects
set_permissions() {
    project_dir="$1"

    # Check if the project directory exists
    if [ -d "$project_dir" ]; then
        # Change ownership of the entire project directory to the web server user (e.g., www-data for Apache)
        sudo chmod -R a+rwx "$project_dir"
    fi
}
# Prompt the user to enter the project name
read -p "Enter the name of the Laravel project: " projectName

# Call functions to set up the project
create_laravel_project $projectName
create_virtual_host $projectName
enable_virtual_host $projectName
update_hosts_file $projectName
set_permissions "/var/www/html/$projectName"

read -p "Enter the name of the database: " DATABASE_NAME

create_db $DATABASE_NAME


#!/bin/bash



# Usage: Call the function with the project directory as an argument


echo "Laravel project '$projectName' has been created with Database $DATABASE_NAME "
echo "You can run the project via the following link:"
echo "http://$projectName.local"
