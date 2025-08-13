<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Datas extends Model
{
    use HasFactory;
    protected $fillable = [
        'lang',
        'text',
        'phone_number',
        'email',
        'bottle_price',
        'liter_price',
        'ton_price',
   ];
}
