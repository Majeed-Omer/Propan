<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Orders extends Model
{
    use HasFactory;
    protected $fillable = [
        'name',
        'rate',
        'price',
        'user_id',
        'pay',
        'driver_id',
        'place_name',
        'latitude',
        'longitude'
    ];

    // Order.php

public function user()
{
    return $this->belongsTo(User::class);
}

}
