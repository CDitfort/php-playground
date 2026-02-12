<div align="center">

# 🐘 PHP Playground

### A fully-featured Docker-based PHP development environment

![PHP Version](https://img.shields.io/badge/PHP-8.2-777BB4?logo=php&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![MariaDB](https://img.shields.io/badge/MariaDB-Latest-003545?logo=mariadb&logoColor=white)

**Zero configuration. Production-ready. Framework agnostic.**

[Features](#-features) • [Quick Start](#-quick-start) • [Documentation](#-project-structure) • [Contributing](#-contributing)

</div>

---

## 📖 About

PHP Playground is a complete, Docker-powered PHP development environment that just works. No complex setup, no version conflicts, no headaches. Perfect for learning PHP, building projects, or testing frameworks like Laravel, WordPress, and Symfony.

### Why PHP Playground?

- 🚀 **Ready in 30 seconds** - One command to start developing
- 🔧 **Zero configuration** - Sensible defaults that just work
- 🐛 **Professional debugging** - Xdebug 3.3 pre-configured for VSCode & PHPStorm
- 📧 **Email testing** - Never send test emails to real addresses again
- 🔒 **HTTPS ready** - Self-signed certificates included
- 📦 **Multi-project support** - Run multiple PHP projects simultaneously

## ✨ Features

### Core Features
- ✅ **PHP 8.2** with Apache
- ✅ **Composer** - Dependency management
- ✅ **mysqli + PDO** - Database drivers pre-installed
- ✅ **Apache Rewrite** - WordPress permalinks ready
- ✅ **Persistent MariaDB** - Data survives container restarts
- ✅ **Folder-based projects** - Multiple projects in one environment
- ✅ **Framework ready** - Works with Laravel, WordPress, Symfony, etc.

### Development Tools
- 🔥 **Xdebug 3.3** - Step debugging and profiling
- 🔥 **PHP.ini overrides** - Customizable PHP settings
- 🔥 **HTTPS** - Self-signed SSL certificates
- 🔥 **Mailhog** - Test email sending without sending real emails

## 🚀 Quick Start

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# Rebuild after config changes
docker compose build
docker compose up -d

# View logs
docker compose logs -f

# Restart services
docker compose restart
```

## 🌐 Access Points

- **HTTP Dev Server**: http://localhost
- **HTTPS Dev Server**: https://localhost
- **phpMyAdmin**: http://localhost:3001
- **Mailhog UI**: http://localhost:3026
- **Database**: localhost:3306

## 🗄️ Database Credentials

- **Database**: `playground`
- **User**: `user`
- **Password**: `password`
- **Root Password**: `root`

## 📁 Project Structure

Each project lives in its own folder:

```
PHP_Playground/
├── docker-compose.yml
├── Dockerfile
├── php.ini              # PHP configuration overrides
├── apache/
│   ├── vhosts.conf      # HTTP virtual hosts
│   └── vhosts-ssl.conf  # HTTPS virtual hosts
├── project1/
│   └── index.php
├── project2/
│   └── index.php
└── test/
    └── index.php
```

## 🎯 Working with Multiple Projects

All folders are mapped to the web server using standard folder-based URLs:
- `http://localhost/project1/`
- `http://localhost/project2/`
- `http://localhost/test/`

Simply create a new folder in the project root and access it via `http://localhost/foldername/`

**HTTPS Support**: All projects are also accessible via HTTPS:
- `https://localhost/project1/`
- `https://localhost/test/`

## 🐛 Xdebug Configuration

### Visual Studio Code
1. Install the **PHP Debug** extension
2. Add to `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Listen for Xdebug",
      "type": "php",
      "request": "launch",
      "port": 9003,
      "pathMappings": {
        "/var/www/html": "${workspaceFolder}"
      }
    }
  ]
}
```
3. Set breakpoints and press F5 to start debugging

### PHPStorm
1. Go to **Settings → PHP → Servers**
2. Add server:
   - Name: `localhost`
   - Host: `localhost`
   - Port: `80`
   - Debugger: `Xdebug`
   - Use path mappings: Map project root to `/var/www/html`
3. Start listening for connections (phone icon)

## ⚙️ PHP.ini Overrides

Edit `php.ini` to customize PHP settings:

```ini
memory_limit = 256M
upload_max_filesize = 64M
post_max_size = 64M
max_execution_time = 300
display_errors = On
```

After changes, rebuild:
```bash
docker compose build && docker compose up -d
```

### Per-Folder PHP Overrides

You can override PHP settings for specific projects using `.htaccess` files:

**Option 1: Using .htaccess** (recommended)

Create a `.htaccess` file in your project folder:

```apache
# project1/.htaccess
php_value memory_limit 512M
php_value upload_max_filesize 100M
php_value post_max_size 100M
php_value max_execution_time 600
php_flag display_errors On
php_flag log_errors On
```

**Option 2: Using .user.ini**

Create a `.user.ini` file in your project folder:

```ini
# project1/.user.ini
memory_limit = 512M
upload_max_filesize = 100M
post_max_size = 100M
max_execution_time = 600
display_errors = On
```

**Note**: `.htaccess` changes apply immediately, while `.user.ini` may require a few seconds to take effect due to caching.

**Common settings you might override per project:**
- `memory_limit` - For memory-intensive applications
- `upload_max_filesize` / `post_max_size` - For file upload applications
- `max_execution_time` - For long-running scripts or batch processing
- `error_reporting` / `display_errors` - Different error levels per environment

## 🔒 HTTPS / SSL

Self-signed certificates are automatically generated. To use HTTPS:

1. Access via: `https://localhost`
2. Browser will warn about self-signed cert (this is normal for development)
3. Accept the security warning to proceed

For production, replace certificates in container at:
- `/etc/apache2/ssl/server.crt`
- `/etc/apache2/ssl/server.key`

## 📧 Email Testing with Mailhog

Mailhog intercepts all emails sent by PHP:

1. **Send emails** using PHP's `mail()` function:
```php
mail('test@example.com', 'Subject', 'Message body');
```

2. **View emails** at http://localhost:3026

All emails are caught by Mailhog and never actually sent. Perfect for testing registration emails, password resets, etc.

## 📦 Using Composer

Composer is pre-installed in the container:

```bash
# Install dependencies
docker compose exec web composer install

# Require a package
docker compose exec web composer require vendor/package

# Update packages
docker compose exec web composer update

# Run composer from project folder
docker compose exec web composer install -d /var/www/html/myproject
```

## 🛠️ Useful Commands

```bash
# Access PHP container shell
docker compose exec web bash

# Run PHP commands
docker compose exec web php -v
docker compose exec web php script.php

# Access MariaDB
docker compose exec db mysql -u root -p

# View real-time logs
docker compose logs -f web
docker compose logs -f db

# Remove all containers and volumes (fresh start)
docker compose down -v

# Check container status
docker compose ps
```

## 🎨 Framework-Specific Setup

### Laravel
```bash
# Create new Laravel project
docker compose exec web composer create-project laravel/laravel myapp
# Access at: http://localhost/myapp/public
```

### WordPress
1. Download WordPress to a folder
2. Access setup: `http://localhost/wordpress`
3. Use database credentials above
4. Permalinks work automatically (mod_rewrite enabled)

### Symfony
```bash
# Create new Symfony project
docker compose exec web composer create-project symfony/skeleton myapp
# Access at: http://localhost/myapp/public
```

## 🔧 Troubleshooting

### Port Already in Use
If ports 80, 443, 3001, or 3026 are in use, edit `docker-compose.yml`:
```yaml
ports:
  - "8000:80"   # Change left number (host port)
  - "8443:443"  # Change left number (host port)
```

### Permission Issues
On Linux/Mac, fix file permissions:
```bash
sudo chown -R $USER:$USER .
```

### Can't Connect to Database
Ensure containers are running:
```bash
docker compose ps
```

### Xdebug Not Working
Check the Xdebug log:
```bash
docker compose exec web cat /tmp/xdebug.log
```

## 🧹 Clean Up

```bash
# Stop and remove containers
docker compose down

# Remove containers and volumes (deletes database data)
docker compose down -v

# Remove images
docker compose down --rmi all
```

## 📚 Additional Resources

- [PHP Official Documentation](https://www.php.net/docs.php)
- [Composer Documentation](https://getcomposer.org/doc/)
- [Xdebug Documentation](https://xdebug.org/docs/)
- [Apache Documentation](https://httpd.apache.org/docs/)
- [MariaDB Documentation](https://mariadb.org/documentation/)

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Ideas for Contributions
- Add support for additional PHP versions
- Include more framework examples
- Improve documentation
- Add testing tools (PHPUnit, Pest)
- Create setup scripts for common scenarios

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Show Your Support

If this project helped you, please consider giving it a ⭐ on GitHub!

## 🙏 Acknowledgments

- Built with [Docker](https://www.docker.com/)
- Powered by [PHP](https://www.php.net/), [Apache](https://httpd.apache.org/), and [MariaDB](https://mariadb.org/)
- Email testing by [Mailhog](https://github.com/mailhog/MailHog)

---

<div align="center">

**Made with ❤️ for the PHP community**

[Report Bug](https://github.com/yourusername/php-playground/issues) • [Request Feature](https://github.com/yourusername/php-playground/issues)

</div>
