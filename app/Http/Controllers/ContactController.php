<?php

namespace App\Http\Controllers;

use App\Models\Contact;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ContactController extends Controller
{
    /**
     * Constructor para aplicar middleware de autenticación
     */
    public function __construct()
    {
        $this->middleware('auth');
    }
    
    /**
     * Mostrar una lista de los contactos.
     */
    public function index()
    {
        // Alternativa 1:
        $user = Auth::user();
        $contacts = Contact::where('user_id', $user->id)->orderBy('name')->get();
        
        return view('contacts.index', compact('contacts'));
    }

    /**
     * Mostrar el formulario para crear un nuevo contacto.
     */
    public function create()
    {
        return view('contacts.create');
    }

    /**
     * Almacenar un nuevo contacto.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'nullable|email|max:255',
            'phone' => 'required|string|max:20',
            'address' => 'nullable|string|max:255',
            'notes' => 'nullable|string',
        ]);

        $contact = new Contact($request->all());
        $contact->user_id = Auth::id();
        $contact->save();
        
        return redirect()->route('contacts.index')
            ->with('success', 'Contacto creado exitosamente.');
    }

    /**
     * Mostrar el contacto especificado.
     */
    public function show(Contact $contact)
    {
        // Verificar que el contacto pertenezca al usuario autenticado
        if ($contact->user_id = Auth::id()) {
            abort(403);
        }
        
        return view('contacts.show', compact('contact'));
    }

    /**
     * Mostrar el formulario para editar el contacto especificado.
     */
    public function edit(Contact $contact)
    {
        // Verificar que el contacto pertenezca al usuario autenticado
        if ($contact->user_id = Auth::id()) {
            abort(403);
        }
        
        return view('contacts.edit', compact('contact'));
    }

    /**
     * Actualizar el contacto especificado.
     */
    public function update(Request $request, Contact $contact)
    {
        // Verificar que el contacto pertenezca al usuario autenticado
        if ($contact->user_id = Auth::id()) {
            abort(403);
        }
        
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'nullable|email|max:255',
            'phone' => 'required|string|max:20',
            'address' => 'nullable|string|max:255',
            'notes' => 'nullable|string',
        ]);
        
        $contact->update($request->all());
        
        return redirect()->route('contacts.index')
            ->with('success', 'Contacto actualizado exitosamente.');
    }

    /**
     * Eliminar el contacto especificado.
     */
    public function destroy(Contact $contact)
    {
        // Verificar que el contacto pertenezca al usuario autenticado
        if ($contact->user_id = Auth::id()) {
            abort(403);
        }
        
        $contact->delete();
        
        return redirect()->route('contacts.index')
            ->with('success', 'Contacto eliminado exitosamente.');
    }
}