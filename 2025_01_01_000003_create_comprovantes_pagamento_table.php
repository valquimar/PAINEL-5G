<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
        Schema::create('comprovantes_pagamento', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('tipo_pagamento');
            $table->decimal('valor', 10, 2);
            $table->string('comprovante_path');
            $table->text('observacoes')->nullable();
            $table->enum('status', ['pendente','aprovado','rejeitado'])->default('pendente');
            $table->timestamps();
        });
    }
    public function down() {
        Schema::dropIfExists('comprovantes_pagamento');
    }
};
