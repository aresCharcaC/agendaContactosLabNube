<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class PostgresUrlServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        if ($databaseUrl = env('DATABASE_URL')) {
            $this->parseDatabaseUrl($databaseUrl);
        }
    }

    /**
     * Parse the DATABASE_URL env variable to set other environment variables.
     */
    protected function parseDatabaseUrl(string $databaseUrl): void
    {
        $url = parse_url($databaseUrl);

        if (isset($url['scheme']) && $url['scheme'] === 'postgres') {
            // Set the database variables from the parsed URL
            $_ENV['DB_CONNECTION'] = 'pgsql';
            $_ENV['DB_HOST'] = $url['host'] ?? '127.0.0.1';
            $_ENV['DB_PORT'] = $url['port'] ?? '5432';
            $_ENV['DB_DATABASE'] = ltrim($url['path'] ?? '', '/');
            $_ENV['DB_USERNAME'] = $url['user'] ?? '';
            $_ENV['DB_PASSWORD'] = $url['pass'] ?? '';
            
            // Update the environment variables in the Laravel application
            putenv('DB_CONNECTION=pgsql');
            putenv('DB_HOST=' . $_ENV['DB_HOST']);
            putenv('DB_PORT=' . $_ENV['DB_PORT']);
            putenv('DB_DATABASE=' . $_ENV['DB_DATABASE']);
            putenv('DB_USERNAME=' . $_ENV['DB_USERNAME']);
            putenv('DB_PASSWORD=' . $_ENV['DB_PASSWORD']);
        }
    }
}