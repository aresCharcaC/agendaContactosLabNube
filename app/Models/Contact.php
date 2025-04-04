<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Contact extends Model
{
    use HasFactory;

    /**
     * Los atributos que son asignables en masa.
     *
     * @var array
     */
    protected $fillable = [
        'name',
        'email',
        'phone',
        'address',
        'notes',
        'user_id'
    ];

    /**
     * Obtener el usuario propietario del contacto.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}