<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\PlacesController;
// use App\Http\Controllers\AboutUSController;
use App\Http\Controllers\OrdersDeliversController;
use App\Http\Controllers\UsersController;
use App\Http\Controllers\OrdersController;
use App\Http\Controllers\SendNotificationsController;
use App\Http\Controllers\DatasController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/auth/signup', [AuthController::class, 'signup']);
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('/validator', [AuthController::class, 'validator']);

Route::post('/orders', [OrdersController::class, 'store'])->middleware('auth:sanctum');
Route::get('/orders', [OrdersController::class, 'index'])->middleware('auth:sanctum');
Route::put('/orders/{orders}', [OrdersController::class, 'update'])->middleware(['auth:sanctum', 'checkUserRole']);
Route::delete('/places/{places}', [PlacesController::class, 'destroy'])->middleware('auth:sanctum');
Route::get('/places', [PlacesController::class, 'index'])->middleware('auth:sanctum');
Route::post('/places', [PlacesController::class, 'store'])->middleware('auth:sanctum');
Route::put('/places/{places}', [PlacesController::class, 'update'])->middleware('auth:sanctum');

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
Route::get('/users', [UsersController::class, 'index'])->middleware('auth:sanctum');
Route::get('/userWithRole/{role}', [UsersController::class, 'userWithRole'])->middleware('auth:sanctum');

Route::middleware('auth:sanctum')->get('/ordersDelivery', [OrdersDeliversController::class, 'index']);
Route::put('/ordersDelivery/{order}', [OrdersDeliversController::class, 'update'])->middleware('auth:sanctum');

Route::post('/upload-image', [UsersController::class, 'uploadImage'])->middleware('auth:sanctum');
Route::put('/reset-password/{user}', [UsersController::class, 'resetPassword'])->middleware('auth:sanctum');
Route::post('/send-notification', [SendNotificationsController::class, 'sendNotification'])->middleware('auth:sanctum');
Route::post('/device-id', [SendNotificationsController::class, 'storeId'])->middleware('auth:sanctum');
Route::post('/send-admin-notification/{id}', [SendNotificationsController::class, 'sendAdminNotification'])
    ->middleware(['auth:sanctum', 'checkUserRole']);

Route::get('/datas/{lang}', [DatasController::class, 'getDatas'])->middleware('auth:sanctum');

// Route::get('/datas', [DatasController::class, 'getAboutUs'])->middleware('auth:sanctum');
