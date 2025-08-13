<?php

namespace App\Http\Controllers;

use App\Models\Places;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PlacesController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $user = Auth::user();
        $places = Places::where('user_id', $user->id)->get();
        return response()->json($places);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $input = $request->validate([
            'name' => 'required',
            'latitude' => 'required',
            'longitude' => 'required',
        ]);
        $places = new Places();
        $places->name = $input['name'];
        $places->latitude = $input['latitude'];
        $places->longitude = $input['longitude'];
        $places->user_id = Auth::id();
        $places->save();

        return response()->json($places);
    }
    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Places  $places
     * @return \Illuminate\Http\Response
     */
    public function show(Places $places)
    {
        return response()->json($places);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Places  $places
     * @return \Illuminate\Http\Response
     */

    public function update(Request $request, $id) { 
        $places = Places::find($id); 
    
        if ($request->has('name')) {
            $places->name = $request->name; 
        }
        if ($request->has('latitude')) {
            $places->latitude = $request->latitude; 
        }
        if ($request->has('longitude')) {
            $places->longitude = $request->longitude; 
        }
        
        $places->save();
        return response()->json($places);
        
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Places  $places
     * @return \Illuminate\Http\Response
     */
    public function destroy(Places $places)
    {
        return response()->json($places->delete());
    }
}
