@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">{{ __('Detalles del Contacto') }}</div>

                <div class="card-body">
                    <div class="row mb-3">
                        <label class="col-md-4 col-form-label text-md-right fw-bold">{{ __('Nombre') }}</label>
                        <div class="col-md-6">
                            <p class="form-control-static">{{ $contact->name }}</p>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label class="col-md-4 col-form-label text-md-right fw-bold">{{ __('Email') }}</label>
                        <div class="col-md-6">
                            <p class="form-control-static">{{ $contact->email ?: 'No especificado' }}</p>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label class="col-md-4 col-form-label text-md-right fw-bold">{{ __('Teléfono') }}</label>
                        <div class="col-md-6">
                            <p class="form-control-static">{{ $contact->phone }}</p>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label class="col-md-4 col-form-label text-md-right fw-bold">{{ __('Dirección') }}</label>
                        <div class="col-md-6">
                            <p class="form-control-static">{{ $contact->address ?: 'No especificada' }}</p>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label class="col-md-4 col-form-label text-md-right fw-bold">{{ __('Notas') }}</label>
                        <div class="col-md-6">
                            <p class="form-control-static">{{ $contact->notes ?: 'Sin notas' }}</p>
                        </div>
                    </div>

                    <div class="row mb-0">
                        <div class="col-md-6 offset-md-4">
                            <a href="{{ route('contacts.edit', $contact->id) }}" class="btn btn-warning">
                                {{ __('Editar') }}
                            </a>
                            <a href="{{ route('contacts.index') }}" class="btn btn-secondary">
                                {{ __('Volver') }}
                            </a>
                            <form action="{{ route('contacts.destroy', $contact->id) }}" method="POST" style="display: inline-block;">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-danger" onclick="return confirm('¿Estás seguro?')">Eliminar</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection