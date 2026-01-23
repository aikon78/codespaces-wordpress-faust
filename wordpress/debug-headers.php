<?php
header('Content-Type: text/plain');
echo "=== DEBUG HEADERS ===\n\n";
echo "HTTP_HOST: " . ($_SERVER['HTTP_HOST'] ?? 'not set') . "\n";
echo "SERVER_NAME: " . ($_SERVER['SERVER_NAME'] ?? 'not set') . "\n";
echo "REQUEST_URI: " . ($_SERVER['REQUEST_URI'] ?? 'not set') . "\n";
echo "HTTP_X_FORWARDED_HOST: " . ($_SERVER['HTTP_X_FORWARDED_HOST'] ?? 'not set') . "\n";
echo "HTTP_X_FORWARDED_PROTO: " . ($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? 'not set') . "\n";
echo "CODESPACE_NAME env: " . (getenv('CODESPACE_NAME') ?: 'not set') . "\n";
echo "GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN env: " . (getenv('GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN') ?: 'not set') . "\n";
echo "\nAll headers:\n";
foreach (getallheaders() as $name => $value) {
    echo "$name: $value\n";
}
