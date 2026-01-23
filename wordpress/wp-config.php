<?php

/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** Database username */
define('DB_USER', 'wordpress');

/** Database password */
define('DB_PASSWORD', 'wordpress');

/** Database hostname */
define('DB_HOST', 'db');

/** Database charset to use in creating database tables. */
define('DB_CHARSET', 'utf8mb4');

/** The database collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define('WP_DEBUG', false);

/* Add any custom values between this line and the "stop editing" line. */

/* Configurazione dinamica per Codespaces */
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}

// Rilevamento ambiente Codespaces
$is_codespaces = !empty(getenv('CODESPACE_NAME'));
$codespace_name = getenv('CODESPACE_NAME');
$forwarding_domain = getenv('GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN');

// Rileva anche dall'host della richiesta
if (!$is_codespaces && isset($_SERVER['HTTP_HOST'])) {
    if (strpos($_SERVER['HTTP_HOST'], '.app.github.dev') !== false) {
        $is_codespaces = true;
        // Estrai il nome del codespace dall'host
        if (preg_match('/^(.+?)-\d+\.app\.github\.dev$/', $_SERVER['HTTP_HOST'], $matches)) {
            $codespace_name = $matches[1];
            $forwarding_domain = 'app.github.dev';
        }
    }
}

if ($is_codespaces && !empty($codespace_name) && !empty($forwarding_domain)) {
    define('WP_HOME', 'https://' . $codespace_name . '-80.' . $forwarding_domain);
    define('WP_SITEURL', 'https://' . $codespace_name . '-80.' . $forwarding_domain);
} else {
    define('WP_HOME', 'http://localhost');
    define('WP_SITEURL', 'http://localhost');
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if (! defined('ABSPATH')) {
	define('ABSPATH', __DIR__ . '/');
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
