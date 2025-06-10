<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
        Schema::create('conexoes_privadas', function (Blueprint $table) {
            $table->id();
            $table->string('nome');
            $table->string('operadora');
            $table->string('protocolo');
            $table->text('payload');
            $table->string('sni')->nullable();
            $table->string('tls_ip')->nullable();
            $table->string('proxy_ip')->nullable();
            $table->string('proxy_port')->nullable();
            $table->enum('status', ['ativo','inativo'])->default('ativo');
            $table->string('categoria')->nullable();
            $table->timestamps();
        });
    }
    public function down() {
        Schema::dropIfExists('conexoes_privadas');
    }
};
