<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'wp-admin');
define('DB_PASSWORD', 'password');
define('DB_HOST', '127.0.0.1:/var/lib/mysql/mysqld.sock');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
define('WP_ALLOW_REPAIR', true);

$table_prefix = 'wp_';

define('WP_DEBUG', false);

if (!defined('ABSPATH')) {
  define('ABSPATH', dirname( __FILE__ ) . '/');
}

require_once(ABSPATH . 'wp-settings.php');