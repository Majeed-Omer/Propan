<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Orders;
use Illuminate\Support\Facades\Auth;

class OrdersController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $user = Auth::user();
        if ($user->roles === 'admin') {
            $orders = Orders::with('user')->get();
        } else {
            $orders = Orders::where('user_id', $user->id)->get(); // Retrieve user-specific orders
        }
        return response()->json($orders);
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
            'rate' => 'required',
            'price' => 'required',
            'place_name' => 'required',
            'latitude' => 'required',
            'longitude' => 'required',
        ]);

        $orders = new Orders();
        $orders->name = $input['name'];
        $orders->rate = $input['rate'];
        $orders->price = $input['price'];
        $orders->place_name = $input['place_name'];
        $orders->latitude = $input['latitude'];
        $orders->longitude = $input['longitude'];
        $orders->user_id = Auth::id();
        $orders->save();

        return response()->json($orders);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Orders  $orders
     * @return \Illuminate\Http\Response
     */
    public function show(int $order_id)
    {
        $order = Orders::findOrFail($order_id);

        return $order;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Orders  $orders
     * @return \Illuminate\Http\Response
     */
    public function update(Request $req, $id) { 
        $orders = Orders::find($id); 
    
        $orders->driver_id = $req->driver_id; 
        
        $orders->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Orders  $orders
     * @return \Illuminate\Http\Response
     */
    public function destroy(Orders $orders)
    {
        return response()->json($orders->delete());
    }
}
