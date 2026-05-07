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
- ✅ **PHP 8.2** with Apache (mod_php)
- ✅ **Composer** - Dependency management
- ✅ **mysqli + PDO** - Database drivers pre-installed
- ✅ **Apache Rewrite** - WordPress permalinks ready
- ✅ **Persistent MariaDB** - Data survives container restarts
- ✅ **Folder-based projects** - Multiple projects in one environment
- ✅ **Framework ready** - Works with Laravel, WordPress, Symfony, etc.
- ✅ **Instant .htaccess reload** - Per-directory PHP config with hot reloading

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

**Note**: Global php.ini changes require a container restart because PHP reads the configuration file only at startup.

### Per-Folder PHP Overrides

**Important:** This environment uses **mod_php** (PHP as an Apache module). With mod_php, you **must use .htaccess** for per-directory PHP configuration. The `.user.ini` method only works with PHP-FPM/CGI/FastCGI setups.

#### Understanding .htaccess

`.htaccess` (Hypertext Access) is an Apache configuration file that allows you to override server settings on a per-directory basis without modifying the main Apache configuration.

**How .htaccess works:**

1. **Processing Order**: Apache reads `.htaccess` files from the root down to the requested directory
   ```
   /var/www/html/.htaccess           (applied first)
   /var/www/html/project1/.htaccess  (applied second, can override parent)
   /var/www/html/project1/api/.htaccess  (applied last, can override both)
   ```

2. **Inheritance**: Child directories inherit settings from parent `.htaccess` files
3. **Override**: Settings in child directories override parent settings for the same directive
4. **Scope**: Changes only affect the directory containing the `.htaccess` and its subdirectories

**Why use .htaccess for per-folder overrides?**
- ✅ **Isolation**: Each project can have its own PHP settings
- ✅ **Hot reloading**: Changes apply immediately (no restart required)
- ✅ **Version control**: Settings can be committed with your project
- ✅ **Portability**: Settings travel with your project code

**Important**: This environment has `AllowOverride All` enabled in the Apache vhosts configuration, which allows `.htaccess` files to override all settings.

#### Hot Reloading Behavior

Understanding when configuration changes apply without restarting:

| Configuration Method | Hot Reload | Apply Time | Restart Required | Works in mod_php? |
|---------------------|------------|------------|------------------|-------------------|
| **php.ini** (global) | ❌ No | N/A | ✅ Yes (rebuild) | ✅ Yes |
| **.htaccess** (per-folder) | ✅ Yes | **Immediate** | ❌ No | ✅ Yes |
| **.user.ini** (per-folder) | ⚠️ N/A | N/A | N/A | ❌ **No** |

**This environment uses mod_php** - only .htaccess works for per-directory configuration.

**Why .user.ini doesn't work:**
- .user.ini requires PHP-FPM, CGI, or FastCGI
- mod_php (PHP as Apache module) cannot read .user.ini files
- If you create a .user.ini file, it will be **silently ignored**

**Development workflow:**
- Use **php.ini** for settings that rarely change (global defaults)
- Use **.htaccess** for project-specific settings (instant feedback + Apache config)

#### Using .htaccess (Only Option for mod_php)

Create a `.htaccess` file in your project folder:

```apache
# project1/.htaccess

# PHP Configuration Overrides
php_value memory_limit 512M
php_value upload_max_filesize 100M
php_value post_max_size 100M
php_value max_execution_time 600
php_flag display_errors On
php_flag log_errors On

# URL Rewriting (for clean URLs)
RewriteEngine On
RewriteBase /project1/
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php?url=$1 [QSA,L]

# Security: Prevent directory listing
Options -Indexes

# Custom error pages
ErrorDocument 404 /project1/404.php
ErrorDocument 500 /project1/500.php
```

**Syntax:**
- `php_value` - Set a string or number value (e.g., `memory_limit`, `upload_max_filesize`)
- `php_flag` - Set a boolean value using `On` or `Off` (e.g., `display_errors`)

**Why use .htaccess:**
- ✅ Changes apply **immediately** (read on every request)
- ✅ Can configure both Apache and PHP settings
- ✅ No container restart required
- ✅ Works with mod_php (this environment)

#### Practical Example: Different Settings Per Project

```
PHP_Playground/
├── project1/
│   ├── .htaccess          # High memory, large uploads (file processing app)
│   └── index.php
├── project2/
│   ├── .htaccess          # Low memory, fast execution (API)
│   └── index.php
└── test/
    ├── .htaccess          # Debug mode enabled
    └── index.php
```

**project1/.htaccess** (Heavy processing):
```apache
php_value memory_limit 1G
php_value upload_max_filesize 500M
php_value post_max_size 500M
php_value max_execution_time 900
```

**project2/.htaccess** (Lightweight API):
```apache
php_value memory_limit 128M
php_value max_execution_time 30
php_flag display_errors Off
```

**test/.htaccess** (Development/Debug):
```apache
php_flag display_errors On
php_flag display_startup_errors On
php_value error_reporting E_ALL
php_flag html_errors On
```

#### Common Settings You Might Override

| Setting | Purpose | Example Values |
|---------|---------|----------------|
| `memory_limit` | Memory-intensive applications | `128M`, `256M`, `1G` |
| `upload_max_filesize` | Maximum upload file size | `2M`, `64M`, `500M` |
| `post_max_size` | Maximum POST data size | `8M`, `64M`, `500M` |
| `max_execution_time` | Script timeout (seconds) | `30`, `300`, `900` |
| `max_input_time` | Input parsing timeout | `60`, `300` |
| `display_errors` | Show errors on screen | `On`, `Off` |
| `error_reporting` | Error reporting level | `E_ALL`, `E_ALL & ~E_NOTICE` |
| `date.timezone` | Default timezone | `America/New_York`, `UTC` |

#### Testing Your .htaccess Configuration

Create a test file to verify your settings:

```php
<?php
// project1/phpinfo.php
phpinfo();
```

Access `http://localhost/project1/phpinfo.php` and search for your overridden values to confirm they're applied.

**Security tip**: Remove or protect phpinfo.php files in production as they expose server configuration.

#### PHP Architecture Notes

**This environment uses:**
- **PHP 8.2** with **mod_php** (Apache module)
- Per-directory config via **.htaccess only**
- .user.ini files are **not supported** and will be ignored

**To use .user.ini instead:**
You would need to migrate to PHP-FPM (FastCGI Process Manager), which is a different architecture. See the [PHP-FPM vs mod_php comparison](#) for more details.

#### Quick Tips

**Verify your PHP SAPI:**
```bash
docker compose exec web php -r "echo php_sapi_name();"
# Should output: apache2handler (mod_php)
```

**Verify which config file is being used:**
```php
<?php
// Shows which php.ini files are loaded
echo php_ini_loaded_file() . "\n";
echo php_ini_scanned_files();
```

**Debug .htaccess issues:**
```bash
# Check Apache error logs if .htaccess isn't working
docker compose logs web
```

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

## Windows Terminal Shortcuts

PHP and Composer run inside the Docker container, so their binaries cannot be added directly to the Windows PATH. To use commands like `php -v` or `composer install` from PowerShell, create small Windows wrapper scripts that forward commands into the `php_web` container.

Create a user bin folder:

```powershell
mkdir "$env:USERPROFILE\bin" -Force
```

Create `%USERPROFILE%\bin\php.bat`:

```bat
@echo off
docker exec -i -w /var/www/html php_web php %*
```

Create `%USERPROFILE%\bin\composer.bat`:

```bat
@echo off
docker exec -i -w /var/www/html php_web composer %*
```

Add the wrapper folder to your user PATH:

```powershell
$bin = "$env:USERPROFILE\bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ([string]::IsNullOrWhiteSpace($userPath)) {
  [Environment]::SetEnvironmentVariable("Path", $bin, "User")
} elseif (($userPath -split ";") -notcontains $bin) {
  [Environment]::SetEnvironmentVariable("Path", "$userPath;$bin", "User")
}
```

Open a new terminal, start the containers, and verify the shortcuts:

```powershell
docker compose up -d
php -v
composer -V
```

These shortcuts only work while the `php_web` container is running.

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
