<?php
// Verificar la estructura de directorios y permisos
$directories = [
    'storage',
    'storage/app',
    'storage/logs',
    'storage/framework',
    'storage/framework/cache',
    'storage/framework/sessions',
    'storage/framework/views',
    'bootstrap/cache'
];

$results = [];

foreach ($directories as $dir) {
    $path = dirname(__DIR__) . '/' . $dir;
    $results[$dir] = [
        'exists' => file_exists($path),
        'writable' => is_writable($path),
        'permissions' => file_exists($path) ? substr(sprintf('%o', fileperms($path)), -4) : 'N/A'
    ];
}

// Verificar la versión de PHP y extensiones
$phpInfo = [
    'version' => phpversion(),
    'extensions' => get_loaded_extensions(),
    'webserver' => $_SERVER['SERVER_SOFTWARE']
];

// Verificar variables de entorno
$envVars = [
    'APP_ENV' => getenv('APP_ENV'),
    'APP_DEBUG' => getenv('APP_DEBUG'),
    'DB_CONNECTION' => getenv('DB_CONNECTION'),
    'DB_HOST' => getenv('DB_HOST')
];

// Mostrar resultados
header('Content-Type: application/json');
echo json_encode([
    'directories' => $results,
    'php' => $phpInfo,
    'environment' => $envVars
], JSON_PRETTY_PRINT);