<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // LVMDP Inspections Table
        Schema::create('lvmdp_inspections', function (Blueprint $table) {
            $table->id();
            $table->date('date');
            $table->string('time_slot'); // 07:00, 09:00, etc.
            $table->decimal('ampere_r', 10, 2)->nullable();
            $table->decimal('ampere_s', 10, 2)->nullable();
            $table->decimal('ampere_t', 10, 2)->nullable();
            $table->decimal('volt_rs', 10, 2)->nullable();
            $table->decimal('volt_st', 10, 2)->nullable();
            $table->decimal('volt_tr', 10, 2)->nullable();
            $table->decimal('cos_phi', 5, 2)->nullable();
            $table->decimal('kw', 10, 2)->nullable();
            $table->decimal('kwh', 10, 2)->nullable();
            $table->decimal('hz', 5, 2)->nullable();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->boolean('is_synced')->default(true);
            $table->timestamps();
            
            $table->index(['date', 'time_slot']);
            $table->index('user_id');
        });

        // STP Inspections Table
        Schema::create('stp_inspections', function (Blueprint $table) {
            $table->id();
            $table->date('date');
            $table->string('time_slot'); // 09:00, 15:00, 22:00
            $table->enum('grit_chamber_status', ['OK', 'N.OK'])->nullable();
            $table->enum('equalizing_tank_status', ['OK', 'N.OK'])->nullable();
            $table->enum('aeration_status', ['OK', 'N.OK'])->nullable();
            $table->enum('sedimentasi_tank_status', ['OK', 'N.OK'])->nullable();
            $table->enum('effluent_tank_status', ['OK', 'N.OK'])->nullable();
            $table->enum('pump_blower_status', ['OK', 'N.OK'])->nullable();
            $table->text('notes')->nullable();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->boolean('is_synced')->default(true);
            $table->timestamps();
            
            $table->index(['date', 'time_slot']);
            $table->index('user_id');
        });

        // Electrical Logs Table
        Schema::create('electrical_logs', function (Blueprint $table) {
            $table->id();
            $table->date('date');
            $table->tinyInteger('shift'); // 1, 2, 3
            $table->decimal('current_power', 10, 2)->nullable();
            $table->decimal('kwh_wbp', 10, 2)->nullable(); // Waktu Beban Puncak
            $table->decimal('kwh_lwbp', 10, 2)->nullable(); // Luar Waktu Beban Puncak
            $table->decimal('kwh_kvarh', 10, 2)->nullable();
            $table->decimal('voltage_r', 10, 2)->nullable();
            $table->decimal('voltage_s', 10, 2)->nullable();
            $table->decimal('voltage_t', 10, 2)->nullable();
            $table->decimal('current_r', 10, 2)->nullable();
            $table->decimal('current_s', 10, 2)->nullable();
            $table->decimal('current_t', 10, 2)->nullable();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->boolean('is_synced')->default(true);
            $table->timestamps();
            
            $table->index(['date', 'shift']);
            $table->index('user_id');
        });

        // Water Logs Table
        Schema::create('water_logs', function (Blueprint $table) {
            $table->id();
            $table->date('date');
            $table->tinyInteger('shift'); // 1, 2, 3
            $table->decimal('pam_meter', 10, 2)->nullable();
            $table->decimal('deepwell_meter', 10, 2)->nullable();
            $table->decimal('ground_tank_level', 10, 2)->nullable();
            $table->decimal('roof_tank_level', 10, 2)->nullable();
            $table->decimal('booster_pressure', 10, 2)->nullable();
            $table->decimal('flow_meter_reading', 10, 2)->nullable();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->boolean('is_synced')->default(true);
            $table->timestamps();
            
            $table->index(['date', 'shift']);
            $table->index('user_id');
        });

        // Checklists Table
        Schema::create('checklists', function (Blueprint $table) {
            $table->id();
            $table->date('date');
            $table->tinyInteger('shift'); // 1, 2, 3 (night shift = 3)
            $table->enum('genset_condition', ['OK', 'N.OK'])->nullable();
            $table->enum('genset_operational', ['OK', 'N.OK'])->nullable();
            $table->enum('lift_condition', ['OK', 'N.OK'])->nullable();
            $table->enum('lift_operational', ['OK', 'N.OK'])->nullable();
            $table->enum('hydrant_condition', ['OK', 'N.OK'])->nullable();
            $table->enum('hydrant_operational', ['OK', 'N.OK'])->nullable();
            $table->enum('drainage_condition', ['OK', 'N.OK'])->nullable();
            $table->enum('drainage_operational', ['OK', 'N.OK'])->nullable();
            $table->enum('water_system_condition', ['OK', 'N.OK'])->nullable();
            $table->enum('water_system_operational', ['OK', 'N.OK'])->nullable();
            $table->enum('fire_alarm_condition', ['OK', 'N.OK'])->nullable();
            $table->enum('fire_alarm_operational', ['OK', 'N.OK'])->nullable();
            $table->text('other_notes')->nullable();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->boolean('is_synced')->default(true);
            $table->timestamps();
            
            $table->index(['date', 'shift']);
            $table->index('user_id');
        });

        // QR Locations Table
        Schema::create('qr_locations', function (Blueprint $table) {
            $table->id();
            $table->string('qr_code')->unique();
            $table->string('location_name');
            $table->string('equipment_type')->nullable();
            $table->text('description')->nullable();
            $table->decimal('latitude', 10, 8)->nullable();
            $table->decimal('longitude', 11, 8)->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
            
            $table->index('qr_code');
        });

        // Sync Queue Table
        Schema::create('sync_queue', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('table_name');
            $table->unsignedBigInteger('record_id');
            $table->enum('action', ['create', 'update', 'delete']);
            $table->json('payload');
            $table->tinyInteger('retry_count')->default(0);
            $table->boolean('is_processed')->default(false);
            $table->timestamp('processed_at')->nullable();
            $table->timestamps();
            
            $table->index(['user_id', 'is_processed']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sync_queue');
        Schema::dropIfExists('qr_locations');
        Schema::dropIfExists('checklists');
        Schema::dropIfExists('water_logs');
        Schema::dropIfExists('electrical_logs');
        Schema::dropIfExists('stp_inspections');
        Schema::dropIfExists('lvmdp_inspections');
    }
};
