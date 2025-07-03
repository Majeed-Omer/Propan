<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateDatasTable extends Migration
{
    public function up()
    {
        Schema::create('datas', function (Blueprint $table) {
            $table->id();
            $table->enum('lang', ['en', 'ku', 'ar'])->default('en');
            $table->string('text', 2000);
            $table->string('phone_number')->nullable();
            $table->string('email')->nullable();
            $table->string('bottle_price')->nullable();
            $table->string('liter_price')->nullable();
            $table->string('ton_price')->nullable();
            $table->timestamps();

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('datas');
    }
};
