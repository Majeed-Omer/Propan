<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class UsersController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $users = User::all();
        return response()->json($users);
    }

    public function userWithRole($role)
    {
    $adminUsers = User::where('roles', $role)->get();
    return response()->json($adminUsers);
    }

    public function uploadImage(Request $request){
    $user = Auth::user(); // Assuming the user is authenticated
    
    if ($request->hasFile('image')) {
        $image = $request->file('image');
        $imageName = time() . '.' . $image->getClientOriginalExtension();
        $image->move(public_path('images'), $imageName);
        
        $user->image = $imageName;
        $user->save();
        
        return response()->json(['message' => 'Image uploaded successfully']);
    } else {
        return response()->json(['message' => 'Image not found in the request'], 400);
    }
    }
    
    public function resetPassword(Request $request, $id) { 
        $user = User::find($id); 
    
        if ($request->has('password')) {
            $user->password = Hash::make($request->password); 
            $user->save();
        }
        
        return response()->json($user);
    }    
}
