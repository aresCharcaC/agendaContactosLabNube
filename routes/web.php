<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\ContactController;
use Illuminate\Support\Facades\File;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/diagnostics', function () {
    return [
        'app_key' => env('APP_KEY', 'No definida'),
        'storage_exists' => File::exists(storage_path()),
        'storage_writable' => is_writable(storage_path()),
        'cache_exists' => File::exists(storage_path('framework/cache')),
        'cache_writable' => is_writable(storage_path('framework/cache')),
        'logs_exists' => File::exists(storage_path('logs')),
        'logs_writable' => is_writable(storage_path('logs')),
        'framework_exists' => File::exists(storage_path('framework')),
        'app_exists' => File::exists(storage_path('app')),
        'php_version' => PHP_VERSION
    ];
});

Auth::routes();

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');

// Rutas para los contactos (protegidas por autenticación)
Route::resource('contacts', ContactController::class);

// Redireccionar /home a /contacts después de login
Route::get('/home', function () {
    return redirect('/contacts');
})->name('home');