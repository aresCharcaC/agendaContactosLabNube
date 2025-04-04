<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class DatabaseUrlServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     *
     * @return void
     */
    public function register()
    {
        // Parse DATABASE_URL environment variable if available
        if ($url = env('DATABASE_URL')) {
            $parsed = parse_url($url);
            
            if (isset($parsed['scheme']) && $parsed['scheme'] == 'postgres') {
                $host = $parsed['host'] ?? null;
                $port = $parsed['port'] ?? null;
                $database = isset($parsed['path']) ? ltrim($parsed['path'], '/') : null;
                $username = $parsed['user'] ?? null;
                $password = $parsed['pass'] ?? null;
                
                if (!env('DB_HOST') && $host) {
                    putenv("DB_HOST=$host");
                    $_ENV['DB_HOST'] = $host;
                    $_SERVER['DB_HOST'] = $host;
                }
                
                if (!env('DB_PORT') && $port) {
                    putenv("DB_PORT=$port");
                    $_ENV['DB_PORT'] = $port;
                    $_SERVER['DB_PORT'] = $port;
                }
                
                if (!env('DB_DATABASE') && $database) {
                    putenv("DB_DATABASE=$database");
                    $_ENV['DB_DATABASE'] = $database;
                    $_SERVER['DB_DATABASE'] = $database;
                }
                
                if (!env('DB_USERNAME') && $username) {
                    putenv("DB_USERNAME=$username");
                    $_ENV['DB_USERNAME'] = $username;
                    $_SERVER['DB_USERNAME'] = $username;
                }
                
                if (!env('DB_PASSWORD') && $password) {
                    putenv("DB_PASSWORD=$password");
                    $_ENV['DB_PASSWORD'] = $password;
                    $_SERVER['DB_PASSWORD'] = $password;
                }
                
                // Force PostgreSQL connection
                putenv("DB_CONNECTION=pgsql");
                $_ENV['DB_CONNECTION'] = 'pgsql';
                $_SERVER['DB_CONNECTION'] = 'pgsql';
            }
        }
    }
}