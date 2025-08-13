<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Orders;
use App\Models\User;
use Illuminate\Support\Facades\Auth;


class OrdersDeliversController extends Controller
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
            $orders = Orders::where('driver_id', '!=', 0)->get();
        } else {
        $orders = Orders::with('user')
                   ->where('driver_id', $user->id)
                   ->get();
               }
        return response()->json($orders);
    }

    public function update(Request $req, $id) { 
        $orders = Orders::find($id); 
    
        if ($req->has('pay')) {
            $orders->pay = $req->pay; 
        }
    
        if ($req->has('driver_id')) {
            $orders->driver_id = $req->driver_id; 
        }
        
        $orders->save();
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
    
}
