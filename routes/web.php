<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\ContactController;

Route::get('/', function () {
    return view('welcome');
});

Auth::routes();

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');

// Rutas para los contactos (protegidas por autenticación)
Route::resource('contacts', ContactController::class);

// Redireccionar /home a /contacts después de login
Route::get('/home', function () {
    return redirect('/contacts');
})->name('home');