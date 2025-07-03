<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use App\Models\Orders;

class SendNotificationsController extends Controller
{

    public function storeId(Request $request)
    {
        $user = Auth::user();

        $input = $request->validate([
            'device_id' => 'required',
        ]);
        $user->device_id = $input['device_id'];
        $user->save();

        return response()->json($user);
    }

    public function sendNotification(Request $request){
    // Get all users
    $users = User::all();

    $lastOrder = Orders::latest('created_at')->first();

    foreach ($users as $user) {
        // Set a flag indicating whether the user is an admin
        if($user->roles === 'admin'){
            $SERVER_API_KEY = 'AAAARS4NHM4:APA91bHveKoOb3nazhwD88kq3k7QG4frRfksFxVtxYRv4b0RIJV7lBsdXhJAQJBSknaOk_BVyqJy5rQCJTHhcZ_mzSvu_272ybXNPZuXzh3d0_HoD5xYYZVm2WpG-quBbTZRikUZH80u';

        $token_1 = $user->device_id;
    
        $data = [
    
            "registration_ids" => [
                $token_1
            ],
    
            "notification" => [
    
                "title" => 'Welcome',
    
                "body" => "a {$lastOrder->rate} gas to {$lastOrder->place_name}",
    
                "sound"=> "default" // required for sound on ios
    
            ],

        ];
    
        $dataString = json_encode($data);
    
        $headers = [
    
            'Authorization: key=' . $SERVER_API_KEY,
    
            'Content-Type: application/json',
    
        ];
    
        $ch = curl_init();
    
        curl_setopt($ch, CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send');
    
        curl_setopt($ch, CURLOPT_POST, true);
    
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    
        curl_setopt($ch, CURLOPT_POSTFIELDS, $dataString);
    
        $response = curl_exec($ch);
        }
        
    }

    return response()->json(['message' => 'Notifications sent']);
    }

    public function sendAdminNotification($id){
        // Find the user with the specified ID
        $user = User::find($id);

        $lastOrder = Orders::where('driver_id', $id)
        ->latest('created_at')
        ->first();
    
        // Check if the user with the specified ID exists
        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }
    
        // Set the SERVER_API_KEY and other data
        $SERVER_API_KEY = 'AAAARS4NHM4:APA91bHveKoOb3nazhwD88kq3k7QG4frRfksFxVtxYRv4b0RIJV7lBsdXhJAQJBSknaOk_BVyqJy5rQCJTHhcZ_mzSvu_272ybXNPZuXzh3d0_HoD5xYYZVm2WpG-quBbTZRikUZH80u';
        $token_1 = $user->device_id;
        
        $data = [
            "registration_ids" => [
                $token_1
            ],
            "notification" => [
                "title" => 'Orders',
                "body" => "take {$lastOrder->rate} gas to {$lastOrder->place_name}",
                "sound"=> "default" // required for sound on iOS
            ],
        ];
    
        $dataString = json_encode($data);
    
        $headers = [
            'Authorization: key=' . $SERVER_API_KEY,
            'Content-Type: application/json',
        ];
    
        $ch = curl_init();
    
        curl_setopt($ch, CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send');
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $dataString);
    
        $response = curl_exec($ch);
    
        // Check for errors in the response
        if (curl_errno($ch)) {
            return response()->json(['message' => 'Failed to send notification'], 500);
        }
    
        curl_close($ch);
    
        // Return a response indicating that the notification was sent
        return response()->json(['message' => 'Admin Notification sent']);
    }
    
}
