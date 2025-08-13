<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function signup(Request $req)
    {
    // Validate
    $rules = [
        'name' => 'required',
        'phone_number' => 'required_without:email|unique:users',
        'email' => 'required_without:phone_number|email|unique:users',
        'password' => 'required|string'
    ];

    $validator = Validator::make($req->all(), $rules);

    if ($validator->fails()) {
        return response()->json($validator->errors(), 400);
    }

    // Determine whether to use phone_number or email
    $userData = [
        'name' => $req->name,
        'password' => Hash::make($req->password)
    ];

    if ($req->has('phone_number') && $req->has('email')) {
        // Handle the case when both phone_number and email are present
        // You may want to return an error or choose one of them here
        return response()->json(['message' => 'Both phone_number and email are provided. Choose one.'], 400);
    } elseif ($req->has('phone_number')) {
        $userData['phone_number'] = $req->phone_number;
    } elseif ($req->has('email')) {
        $userData['email'] = $req->email;
    } else {
        // Handle the case when neither phone_number nor email is provided
        return response()->json(['message' => 'Either phone_number or email must be provided.'], 400);
    }

    $user = User::create($userData);

    $token = $user->createToken('Personal Access Token')->plainTextToken;

    $response = ['user' => $user, 'token' => $token];

    return response()->json($response, 200);
    }

    public function login(Request $req)
    {
    // Validate inputs
    $req->validate([
        'identifier' => 'required', // Rename 'phone_number' to 'identifier'
        'password' => 'required|string'
    ]);

    // Check if the provided input is an email or a phone number
    $identifier = $req->identifier;
    $user = User::where(function ($query) use ($identifier) {
        $query->where('email', $identifier)
            ->orWhere('phone_number', $identifier);
    })->first();

    // If a user is found and the password is correct
    if ($user && Hash::check($req->password, $user->password)) {
        $token = $user->createToken('Personal Access Token')->plainTextToken;
        $response = ['user' => $user, 'token' => $token];
        return response()->json($response, 200);
    }

    $response = ['message' => 'Incorrect email or phone number or password'];
    return response()->json($response, 400);
    }


    public function forgotPassword(Request $req)
    {
        // Validate inputs
    $req->validate([
        'identifier' => 'required',
    ]);

    // Check if the provided input is an email or a phone number
    $identifier = $req->identifier;
    $user = User::where(function ($query) use ($identifier) {
        $query->where('email', $identifier)
            ->orWhere('phone_number', $identifier);
    })->first();

    if ($user) {
        $token = $user->createToken('Personal Access Token')->plainTextToken;
        $response = ['user' => $user, 'token' => $token];
        return response()->json($response, 200);
    }

    $response = ['message' => 'Incorrect email or phone number'];
    return response()->json($response, 400);
    }

    public function validator(Request $req){
        $rules = [
        'name' => 'required',
        'phone_number' => 'required_without:email|unique:users',
        'email' => 'required_without:phone_number|email|unique:users',
        'password' => 'required|string'
        ];
        $validator = Validator::make($req->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }else{
            $response = ['message' => 'Your input is correct'];
        return response()->json($response, 200);
        }
    }
    
}
