<?php
define('DB_NAME', 'wp_db');
define('DB_USER', 'wp_user');
define('DB_PASSWORD', 'admin');
define('DB_HOST', 'mysql');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

$table_prefix = 'wp_';

define('WP_DEBUG', true);
define( 'WP_DEBUG_LOG', true );

if (!defined('ABSPATH')) {
  define('ABSPATH', dirname( __FILE__ ) . '/');
}

require_once(ABSPATH . 'wp-settings.php');